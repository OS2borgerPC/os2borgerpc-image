#!/usr/bin/env python

"""
Script for activating an OS2display screen. Arguments: [url, activation_code]
"""

__author__ = "Danni Als"
__copyright__ = "Copyright 2019, Magenta Aps"
__credits__ = ["Allan Grauenkjaer"]
__license__ = "GPL"
__version__ = "0.1.0"
__maintainer__ = "Magenta"
__email__ = "danni@magenta.dk"
__status__ = "Production"

import os
import sys
import subprocess

subprocess.call([sys.executable, "-m", "pip", "install", 'wget'])
subprocess.call([sys.executable, "-m", "pip", "install", 'selenium'])

print('Installed wget and selenium.')

import wget
import sqlite3
import tarfile

from selenium.webdriver import Firefox, FirefoxProfile
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as expected

print(len(sys.argv))

if len(sys.argv) == 3:
    url = sys.argv[1]
    print(url)
    activation_code = sys.argv[2]
    print(activation_code)
else:
    print('Mangler input parametre.')
    sys.exit(1)

# download gecko and setup
if not os.path.isfile('/usr/local/bin/geckodriver'):
    gecko_url = 'https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-linux64.tar.gz'
    download_path = '/usr/local/bin/geckodriver-v0.24.0-linux64.tar.gz'
    wget.download(gecko_url, download_path)

    extract_path = '/usr/local/bin/'
    tar = tarfile.open(download_path)
    tar.extractall(path=extract_path)
    tar.close()

    print('Geckodriver downloaded and extracted to path: {}'.format(extract_path))
else:
    print('Geckodriver is already setup.')
# start firefox headless
opts = Options()
# opts.set_headless()
opts.add_argument('-headless')
# assert opts.headless  # Operating in headless mode
browser = Firefox(options=opts)
wait = WebDriverWait(browser, timeout=10)
browser.get('' + url)
print('Firefox browser opened headless with url: {}'.format(url))
wait.until(expected.visibility_of_element_located((By.TAG_NAME, 'input'))).send_keys('' + activation_code + Keys.ENTER)

try:
    WebDriverWait(browser, 3).until(expected.alert_is_present(), 'Timed out waiting for alert.')
    alert = browser.switch_to_alert()
    alert.accept()
except:
    print('No alert.')

wait.until(expected.visibility_of_element_located((By.CLASS_NAME, 'default--full-screen')))

token = browser.execute_script("return localStorage.getItem('indholdskanalen_token')")
uuid = browser.execute_script("return localStorage.getItem('indholdskanalen_uuid')")

print('Token: {}'.format(token))
print('UUID: {}'.format(uuid))

browser.close()
print('Firefox headless browser closed.')

db_name = 'webappsstore.sqlite'
for root, dirs, files in os.walk('/home/.skjult/.mozilla/firefox/'):
    if db_name in files:
        db_path = os.path.join(root, db_name)

if db_path:
    print('Connecting to sqlite db_path: {}'.format(db_path))

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    cursor.execute("SELECT sql FROM sqlite_master WHERE name='webappsstore2'")
    rows = cursor.fetchall()
    if 'originAttributes' not in rows[0][0]:
        print('Updating webappsstore2...')
        cursor.execute("DROP TABLE main.webappsstore2 ")
        conn.commit()
        cursor.execute("CREATE TABLE webappsstore2 (originAttributes TEXT, originKey TEXT, scope TEXT, key TEXT, value TEXT)")
        conn.commit()
        cursor.execute("CREATE UNIQUE INDEX origin_key_index ON webappsstore2(originAttributes, originKey, key)")
        conn.commit()
        print('webappsstore2 table has been updated.')

    cursor.execute("SELECT * FROM webappsstore2 WHERE key='indholdskanalen_token'")
    if not len(cursor.fetchall()):
        reverse_url = url[::-1].replace('//:sptth','')
        print('Reverse url used as key: {}'.format(reverse_url))
        cursor.execute("INSERT INTO webappsstore2 VALUES ('','{}.:https:443','{}.:https:443','indholdskanalen_token','{}')".format(reverse_url, reverse_url, token))
        conn.commit()

        cursor.execute("INSERT INTO webappsstore2 VALUES ('','{}.:https:443','{}.:https:443', 'indholdskanalen_uuid','{}')".format(reverse_url + '_', reverse_url, uuid))
        conn.commit()
        print('Token and UUID has been inserted.')
    else:
        cursor.execute("UPDATE webappsstore2 SET value = '{}' WHERE key='indholdskanalen_token'".format(token))
        conn.commit()

        cursor.execute("UPDATE webappsstore2 SET value = '{}' WHERE key='indholdskanalen_uuid'".format(uuid))
        conn.commit()
        print('Token and UUID has been updated.')
    conn.close()
    print('DB updated and connection closed.')
else:
    print('webappsstore file does not exists.')

#!/usr/bin/env python

"""
Script for activating an OS2display screen on Google Chrome. Arguments: [url, activation_code]
"""

__author__ = "Danni Als"
__copyright__ = "Copyright 2019, Magenta Aps"
__credits__ = ["Allan Grauenkjaer"]
__license__ = "GPL"
__version__ = "0.1.2"
__maintainer__ = "Magenta"
__email__ = "danni@magenta.dk"
__status__ = "Production"

import os
import sys
import stat
import subprocess
from urlparse import urlparse

subprocess.call([sys.executable, "-m", "pip", "install", 'wget'])
subprocess.call([sys.executable, "-m", "pip", "install", 'selenium'])
subprocess.call([sys.executable, "-m", "pip", "install", 'plyvel'])

print('Installed wget and selenium.')

import wget
import plyvel
import zipfile

from selenium.webdriver import Chrome
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
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

system_path = '/usr/local/bin'
zipfile_name = 'chromedriver_linux64.zip'
extracted_filename = 'chromedriver'

# download gecko and setup
if not os.path.isfile(os.path.join(system_path, extracted_filename)):
    chromedriver_url = 'https://chromedriver.storage.googleapis.com/74.0.3729.6/chromedriver_linux64.zip'
    wget.download(chromedriver_url, os.path.join(system_path, zipfile_name))

    with zipfile.ZipFile(os.path.join(system_path, zipfile_name), 'r') as z:
        z.extractall(system_path)

    os.chmod(os.path.join(system_path, extracted_filename), stat.S_IRWXU | stat.S_IXGRP | stat.S_IRGRP | stat.S_IXOTH)

    print('Chromedriver downloaded and extracted to path: {}'.format(system_path))
else:
    print('Chromedriver is already setup.')
# start chrome headless
opts = Options()
# opts.set_headless()
opts.add_argument('--headless')
opts.add_argument('--no-sandbox')
opts.add_argument('--disable-dev-shm-usage')
# assert opts.headless  # Operating in headless mode
browser = Chrome(chrome_options=opts, executable_path=os.path.join(system_path, extracted_filename))
wait = WebDriverWait(browser, timeout=10)
browser.get('' + url)
print('Chrome browser opened headless with url: {}'.format(url))
wait.until(expected.visibility_of_element_located((By.TAG_NAME, 'input'))).send_keys('' + activation_code + Keys.ENTER)

try:
    WebDriverWait(browser, 3).until(expected.alert_is_present(), 'Timed out waiting for alert.')
    alert = browser.switch_to_alert()
    alert.accept()
except:
    print('No alert.')

try:
    wait.until(expected.visibility_of_element_located((By.CLASS_NAME, 'default--full-screen')))
except:
    text = browser.findElement(By.className('log--inner is-error').getText())
    print('Exception occured while waiting for OS2display screen: {}'.format(text))
    sys.exit(1)

token = browser.execute_script("return localStorage.getItem('indholdskanalen_token')")
uuid = browser.execute_script("return localStorage.getItem('indholdskanalen_uuid')")

print('Token: {}'.format(token))
print('UUID: {}'.format(uuid))

browser.close()
print('Chrome headless browser closed.')

db_path = '/home/.skjult/.config/google-chrome/Default/Local Storage/'
if not os.path.exists(db_path):
    os.mkdir(db_path)

db_name = 'leveldb/'
db_path += db_name
print('Connecting to leveldb db_path: {}'.format(db_path))

parsed_url = urlparse(url)
url_key = parsed_url.scheme + '://' + parsed_url.netloc

db = plyvel.DB(db_path, create_if_missing=True)
db.put(str('_' + url_key + '\x00\x01indholdskanalen_uuid'), str('\x01' + uuid))
db.put(str('_' + url_key + '\x00\x01indholdskanalen_token'), str('\x01' + token))

db.close()

print('DB updated and connection closed.')


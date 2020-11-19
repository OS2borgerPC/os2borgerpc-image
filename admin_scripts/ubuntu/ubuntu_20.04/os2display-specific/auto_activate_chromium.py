#!/usr/bin/env python

"""
Activates an OS2display screen and runs Chromium in fullscreen. Arguments: [url, activation_code]
The script is based on: image/admin_scripts/ubuntu/ubuntu_16.04/os2display-specific/auto_activate_chrome.py
"""

__author__ = "Danni Als", "Heini L. ovason"
__copyright__ = "Copyright 2020, Magenta Aps"
__credits__ = ["Allan Grauenkjaer"]
__license__ = "GPL"
__version__ = "0.2.0"
__maintainer__ = "Magenta"
__email__ = "danni@magenta.dk", "heini@magenta.dk"
__status__ = "Production"

import os
import glob
import sys
import stat
import subprocess
from urlparse import urlparse

subprocess.call([sys.executable, "-m", "pip", "install", 'wget==3.2'])
subprocess.call([sys.executable, "-m", "pip", "install", 'selenium==3.141.0'])
subprocess.call([sys.executable, "-m", "pip", "install", 'plyvel==1.0.2'])

print('Installed wget, selenium, and plyvel installed.')

import wget
import plyvel
import zipfile

from selenium.webdriver import Chrome
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as expected
from selenium.common.exceptions import InvalidArgumentException

print(len(sys.argv))

if len(sys.argv) == 3:
    url = sys.argv[1]
    print('URL: {}'.format(url))
    activation_code = sys.argv[2]
    print('Aktiveringskode: {}'.format(activation_code))
else:
    print('Mangler input parametre.')
    sys.exit(1)

# Returned string --> 'Chromimum xx.x.xxxx.xx Built on Ubuntu , running on Ubuntu xx.xx'
chromium_version = os.popen('chromium-browser --version').read()
chromium_version = chromium_version.split(' ')
chromium_version = chromium_version[1]
if chromium_version.split('.')[0] == '86':
    driver_version = '86.0.4240.22'
    print('Supported Chromium version installed: {}'.format(chromium_version))   
    print('Chromedriver reference needed: {}'.format(driver_version))
else:
    print('No supported Chromium version installed.')
    print('Supported Chromium versions are listed in the current script.')
    sys.exit(1)

system_path = '/usr/local/bin'
zipfile_name = driver_version + 'chromedriver_linux64.zip'
zip_path = os.path.join(system_path, zipfile_name)
extracted_filename = 'chromedriver'
extracted_filepath = os.path.join(system_path, extracted_filename)

# download gecko and setup
if not os.path.isfile(zip_path):
    try:
        for fl in glob.glob(system_path + '/*chromedriver_linux64.zip'):
            os.remove(fl)
        for fl1 in glob.glob(system_path + '/chromedriver'):
            os.remove(fl1)
    except OSError:
        pass

    chromedriver_url = 'https://chromedriver.storage.googleapis.com/' + driver_version + '/chromedriver_linux64.zip'
    wget.download(chromedriver_url, zip_path)
    print('Driver download complete.')

    with zipfile.ZipFile(zip_path, 'r') as z:
        z.extractall(system_path)

    os.chmod(extracted_filepath, stat.S_IRWXU | stat.S_IXGRP | stat.S_IRGRP | stat.S_IXOTH)

    print('Chromedriver downloaded and extracted to path: {}'.format(
        extracted_filepath)
    )
else:
     print('Chromedriver {} is already setup.'.format(driver_version))

# start chrome headless
opts = Options()
# opts.set_headless()
opts.add_argument('--headless')
opts.add_argument('--no-sandbox')
opts.add_argument('--disable-dev-shm-usage')
# assert opts.headless  # Operating in headless mode
browser = Chrome(chrome_options=opts, executable_path=extracted_filepath)
wait = WebDriverWait(browser, timeout=10)
try:
    browser.get(url)
except InvalidArgumentException as iae:
    print('Invalid argument given: {} of type {}'.format(url, type(url)))
    print(iae.message)
    sys.exit(1)

print('Chromium browser opened headless with url: {}'.format(url))
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

    print('Exception occured while waiting for OS2display screen.')

token = browser.execute_script("return localStorage.getItem('indholdskanalen_token')")
uuid = browser.execute_script("return localStorage.getItem('indholdskanalen_uuid')")

print('Token: {}'.format(token))
print('UUID: {}'.format(uuid))

browser.close()
print('Chromium headless browser closed.')

# Making sure all instances of Chromium are shut down,
# or leveldb will be inaccessible to plyvel
os.system("pkill -o chromium")
os.system("sleep 5")

db_path = '/home/chrome/.config/chromium/Default/Local Storage/'
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


#!/usr/bin/env python

from bibos_client.admin_client import BibOSAdmin
from bibos_utils.bibos_config import BibOSConfig

import urlparse
import subprocess

def get_url_and_uid():
    config = BibOSConfig()
    uid = config.get_value('uid')
    config_data = config.get_data()
    admin_url = config_data.get('admin_url', 'http://bibos.magenta-aps.dk/')
    xml_rpc_url = config_data.get('xml_rpc_url', '/admin-xml/')
    rpc_url = urlparse.urljoin(admin_url, xml_rpc_url)
    return(rpc_url, uid)

if __name__ == '__main__':
    (remote_url, uid) = get_url_and_uid()
    remote = BibOSAdmin(remote_url)

    conf = remote.get_proxy_setup(uid)

    f = open('/etc/squid-deb-proxy/squid-deb-proxy.conf', 'w')
    f.write(conf)
    f.close()
    subprocess.call(['/usr/sbin/service', 'squid-deb-proxy', 'restart'])
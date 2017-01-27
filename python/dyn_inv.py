#!/usr/bin/env python
'''
    Ansible dynamic inventory experiment

    Output dynamic inventory as JSON
'''

import argparse
import json

ANSIBLE_INV = {
    "np_loadbalancer": {
        "hosts": ["centlb01"],
    },
    "np_webserver": {
        "hosts": ["centapp01", "centapp02"],
    },
    "np_database": {
        "hosts": ["centdb01"],
    },
    "np_magent": {
        "children": ["np_loadbalancer", "np_webserver", "np_database"]
    }
}

HOST_VARS = {
    "centlb01": {"x_port": 5555},
    "centapp01": {"x_port": 5556},
    "centapp02": {"x_port": 5557},
    "centdb01": {"x_port": 5558},
}

def output_list_inventory(json_output):
    '''
    output the --list data structure as json
    '''
    print json.dumps(json_output)

def find_host(search_host, inventory):
    '''
    Find the given variables for the given host and output as json
    '''
    host_attribs = inventory.get(search_host, {})
    print json.dumps(host_attribs)


def main():
    parser = argparse.ArgumentParser(description="Ansible Dynamic Inventory")
    parser.add_argument("--list", help="Ansible inventory of all of the groups",
        action="store_true", dest="list_inventory")
    parser.add_argument("--host", help="Ansible inventory for a specific host", action="store",
        dest="ansible_host", type=str)

    cli_args = parser.parse_args()
    list_inventory = cli_args.list_inventory
    ansible_host = cli_args.ansible_host

    if list_inventory:
        output_list_inventory(ANSIBLE_INV)

    if ansible_host:
        find_host(ansible_host, HOST_VARS)

    '''
    print "list inventory: {}".format(list_inventory)
    print "ansible_host: {}".format(ansible_host)
    '''

if __name__=="__main__":
    main()

#! /usr/bin/env python

import boto3
import json

def get_ec2_instances():
    ec2 = boto3.resource('ec2')
    instances = ec2.instances.filter(
        Filters=[
            { 'Name': 'instance-state-name', 'Values': ['running'] }
        ]
    )
    inventory = { 'all' : {'hosts':[]}}

    for instance in instances:
        for tag in instance.tags:
            if tag['Key'] == 'Name':
                inventory['all']['hosts'].append(instance.public_dns_name)
                #inventory['all']['hosts'].append(instance.public_ip_address)
    return inventory

def get_dummynodes():
    inventory = { 'all': { 'hosts': [] } }
    inventory['all']['hosts'].append('localhost')
    inventory['all']['hosts'].append('host1')
    inventory['all']['hosts'].append('host2')
    return inventory

if __name__=="__main__":
    #inventory = get_ec2_instances()
    inventory = get_dummynodes()
    print(json.dumps(inventory))
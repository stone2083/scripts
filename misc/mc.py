#!/usr/bin/env python
import os, sys, time
import bmemcached

def create_client(host, user, password):
    print '%s:%s@%s' % (user, password, host)
    return bmemcached.Client(host, user, password)

def close_client(mc):
    if mc:
        mc.disconnect_all()

def shell_cmd():
    host, user, password = sys.argv[1], sys.argv[2], sys.argv[3]
    mc = create_client(host, user, password)
    key = '%s@__ocs_test_key__' % user
    print mc.set(key, 'hello', 0)
    print mc.get(key)
    print mc.delete(key)
    close_client(mc)

if __name__ == '__main__':
    shell_cmd()

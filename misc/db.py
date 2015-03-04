#!/usr/bin/env python
import mysql.connector

DATASOURCE = {
    'host'      : '',
    'port'      : 3306,
    'database'  : '',
    'user'      : '',
    'password'  : ''
}

def create_connection():
    return mysql.connector.connect(**DATASOURCE)

def count(sql, params=()):
    ret = query(sql, params)
    return ret[0][0]

def query(sql, params=()):
    con = create_connection()
    cursor = con.cursor()
    cursor.execute(sql, params)
    ret = cursor.fetchall()
    con.close()
    return ret

def execute(sql, params=()):
    con = create_connection()
    cursor = con.cursor()
    cursor.execute(sql, params)
    ret = cursor.rowcount
    con.commit()
    con.close()
    return ret

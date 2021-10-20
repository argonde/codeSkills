#!/usr/bin/python3
# -*- coding: utf-8 -*-
# auth: Ruben López Vázquez
# scraps publically available Q&A data on programming languages,
# from sites like stackexchange.com
# -----------------------------------------------------------------


import requests
from bs4 import BeautifulSoup
from IPython.core.display import clear_output
from random import randint
import pandas as pd
import csv
import time as t
import sqlite3
import sys
import os


def is_digit(check_input):
    """
    function to check whether the input is an integer digit
    returns : bool
    """
    if check_input.isdigit():
        return True
    return False


def create_table():
    """
    pass an SQL statement to the database, to create a new table with a Q&A (two fields) schema
    in case that table does not exist yet
    """
    c.execute('CREATE TABLE IF NOT EXISTS SqlSyntax (Inquiry TEXT, Code TEXT)')
    conn.commit()


def data_entry(data):
    """
    pass an SQL statement to the database, to insert new values to the table
    values are always in pairs, to write a line in compliance with the relational data scheme
    """
    insert = "INSERT INTO SqlSyntax (Inquiry, Code) VALUES (?, ?)"
    c.executemany(insert, [data, ])
    conn.commit()


def web_data_html_scrap(page, lang):
    # Output lists
    title = []
    value = []
    exception_dict = {}

    # User requests to get a response from a page
    r = requests.get(page)
    # Use bs to parse the response
    soup = BeautifulSoup(r.text, 'html.parser')

    # Create a list of links, i.e. urls to scrap
    url_links = []
    a = 1
    try:
        # Select all links in 'div' objects from the index page
        for link in soup.findAll('a'):
            url_links.append(url + str(link.get('href')))
            # log all url links to file for inspection, then hash the BREAK command
            a += 1
            if a < len(soup.findAll('a')):
                continue
            else:
                with open(wd + f"all_{lang}_url_links.csv", "w") as f:
                    write_file = csv.writer(f)
                    write_file.writerow(url_links)
                # Customise the url_links slice and then hash the line below
                break
        print("all links found: " + str(len(url_links)))
        re = 1

        def try_despite_exceptions(links, req):
            print("Looking into list of urls ...")
            urls = links[req:len(links)]
            print('There are ' + str(len(urls)) + ' requests left')
            # Preparing the monitoring of the loop
            start_time = t.time()
            # Make a get request
            for u in urls:
                try:
                    r2 = requests.get(u)
                    # Pause the loop
                    t.sleep(randint(1, 3))

                    # Monitor the requests
                    elapsed_time = t.time() - start_time
                    print('Request:{}; Frequency: {} requests/s'.format(req, req / elapsed_time))
                    clear_output(wait=True)

                    # parse the data
                    html_soup = BeautifulSoup(r2.text, 'html.parser')
                    container = html_soup.find('div', class_='answer_info_holder_outer')
                    title.append(container.find('div', class_='answer_info_title').text)
                    value.append(container.find('textarea', class_='code_mirror_code').text)
                    req += 1
                # in case any of the attribute references on previous lines above is not available
                except AttributeError as e:
                    print("Error while fetching data, resuming ...")
                    # catch the exception and log it on the dictionary opened for exceptions
                    exception_dict[u] = e
                    req += 1
                    # as long as there are links left to visit: da Capo
                    if req < len(links):
                        try_despite_exceptions(links, req)
                    # no links left, then do nothing
                    else:
                        pass

        url_links = url_links[10:-15]
        if re < len(url_links):
            return try_despite_exceptions(url_links, re)
        else:
            pass

    except AttributeError as err:
        print("Error while fetching urls in blocks:", err)

    finally:
        # log files, always useful for monitoring operations
        with open(wd + f"log_{lang}_code_column.csv", "a") as f:
            write_file = csv.writer(f)
            write_file.writerow(value)

        with open(wd + f"log_{lang}_title_column.csv", "a") as g:
            write_file = csv.writer(g)
            write_file.writerow(title)

        with open(wd + f"log_{lang}_exceptions.csv", "a") as h:
            write_file = csv.writer(h)
            write_file.writerow(exception_dict)

        # collect raw data into a data.frame
        py_syntax = {'Inquiry': title,
                     'Code': value
                     }
        df = pd.DataFrame(py_syntax, columns=['Inquiry', 'Code'])

        # Create table and populate it
        create_table()
        print("Database created on SQLite")
        for idx, rows in df.iterrows():
            # create a table
            row = [rows['Inquiry'], rows['Code']]
            data_entry(row)
        if conn:
            # close cursor
            c.close()
            # close connection
            conn.close()
            print("The SQLite connection is closed")


#####################################################################################################################
# Gather input data from user
print("\nThis script will collect data from public posts on well-known Q&A sites like stackoverflow.com\n"
      "                       These are the available programming languages:\n")

# variables on the contents of the menu:
langList = ['sql\t\t', 'javascript', 'python\t', 'r\t\t', 'matlab\t', 'shell\t']
langShort = ['SQL', 'JS', 'PY', 'R', 'ML', 'SH']
language = ['SQL: a domain-specific declarative language for managing data in relational databases',
            'JS: an imperative, high-level, event-driven programming language used in front end development',
            'PY: an interpreted, imperative, high-level programming language, often used for scripting',
            'R: a programming language used for numeric/statistical computing, graphics and data analysis',
            'ML: a programming language used for numeric computing, plotting of functions and implementing algorithms',
            'SH: a scripting language or program that automates the execution of tasks on a runtime system']
n = len(langList)
options = {}

# create a dictionary of options to later ensure the user inputs a valid choice
for index, item in enumerate(langList):
    print(f'{index} : {item} \t--> {language[index]}.')
    options[str(item)] = str(language[index])

# create variables to extract input from the while loop
option = ''
optDir = ''
optName = ''
# while the input is not within the range of acceptable answers keep looping
while option not in options.keys():
    # ask the user for the programming language she/he is interested
    option = input("Choose a language to collect syntax and usage examples on a DB.\n"
                   "Select an index number from the menu above, else quit with 'q': ")
    # if case the user wants to quit
    if option == 'q':
        print('\nTransaction cancelled\n')
        print(f'O data downloaded')
        sys.exit()

    # if not 'q', the input from the user must be a digit (integer number)
    elif is_digit(option):
        # catch an error is the integer number provided is out of the range of available options
        try:
            # turn the index into short and long names for the chosen language
            m = int(option)
            langShort = langShort[m]
            optName = str(langList[m]).strip()
            # confirm the user wants to download the data, as well as the language option
            usr_input = input(f'You chose {optName}, do you want to continue? [y/n]: ').lower()

            # if the choice is confirm, ask for a subdirectory where to save the database (none: present dir)
            if usr_input == 'y':
                optDir = input('Enter a subdirectory where to save the data: ').strip("/")
                break

            # If the user does not confirm his/her choice, then quit
            else:
                print('\nTransaction cancelled\n')
                print(f'O data downloaded')
                sys.exit()

        # index error: the digit provided is out of the range provided by the index
        except IndexError:
            print(f'\nThere are {n} choices. Please choose only one of them.\n')
    # If the user does not want to quit 'q', but has not supplied a digit, remind the correct input
    else:
        print(f'\nYou must please enter one of the integer numbers indexing your choice.\n')

# Local variables
url = "https://www.codegrepper.com/code-examples/"+optName
wd = os.path.dirname(os.path.abspath(__file__))+'/'+optDir+'/'
os.chdir(wd)
# prepare to establish a connection to an sqlite database
conn = sqlite3.connect(f'SQLite_{langShort}_Syntax.db')
# create a cursor to operate on the database
c = conn.cursor()
print("Successfully Connected to SQLite")

# send a query to confirm, that the connection was successful
sqlite_select_Query = "select sqlite_version();"
c.execute(sqlite_select_Query)
record = c.fetchall()
# here is proof that it was successful
print("SQLite Database Version is: ", record, '\n')

# begin data collection by calling the python function web_data_html_scrap()
print(f'Collecting list of links to urls ...\n')
print(f'Getting data from the web on {optName}!\n')

web_data_html_scrap(url, langShort)

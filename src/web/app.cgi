#!/usr/bin/python3

import re
from wsgiref.handlers import CGIHandler

from flask import Flask, render_template, request
import psycopg2
import psycopg2.extras

## SGBD configs
DB_HOST = "db.tecnico.ulisboa.pt"
DB_USER = "ist199074"
DB_DATABASE = DB_USER

# with open('../.env', 'r') as f:
#     DB_PASSWORD = f.read()

DB_PASSWORD = r"****"

DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % \
(DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)

app = Flask(__name__)


@app.route('/')
def index():

    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute("SELECT * FROM produto")
        return render_template('index.html', cursor = cursor)

    except Exception as e:
        return str(e)
        
    finally:
        if cursor:
            cursor.close()
        if dbConn:
            dbConn.close()


@app.route('/categorias_simples')
def categorias_simples_list():
    
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute("SELECT * FROM categoria_simples")
        return render_template('categorias_simples_list.html', cursor = cursor, params = request.args)

    except Exception as e:
        return str(e)
        
    finally:
        if cursor:
            cursor.close()
        if dbConn:
            dbConn.close()


@app.route('/categorias_super')
def categorias_super_list():
    
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute("SELECT * FROM super_categoria")
        return render_template('categorias_super_list.html', cursor = cursor, params = request.args)

    except Exception as e:
        return str(e)
        
    finally:
        if cursor:
            cursor.close()
        if dbConn:
            dbConn.close()


@app.route('/categoria_remove', methods=["POST"])
def categoria_remove():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        category_name = request.form['category_name']
        queries = []

        query = "DELETE FROM tem_outra WHERE super_categoria = %s or categoria = %s"
        data = (category_name, category_name)
        cursor.execute(query, data)
        queries.append(cursor.mogrify(query, data).decode('utf-8'))

        query = "DELETE FROM categoria_simples WHERE nome = %s"
        data = (category_name,)
        cursor.execute(query, data)
        queries.append(cursor.mogrify(query, data).decode('utf-8'))

        query = "DELETE FROM super_categoria WHERE nome = %s"
        data = (category_name,)
        cursor.execute(query, data)
        queries.append(cursor.mogrify(query, data).decode('utf-8'))

        query = "DELETE FROM categoria WHERE nome = %s"
        data = (category_name,)
        cursor.execute(query, data)
        queries.append(cursor.mogrify(query, data).decode('utf-8'))

        dbConn.commit()

        return str(queries)

    except Exception as e:
        return str(e)
        
    finally:
        if cursor:
            cursor.close()
        if dbConn:
            dbConn.close()

    

@app.route('/categoria_adicionar')
def categoria_adicionar():
    try:
        return render_template("categoria_adicionar.html", params = request.args)
    except Exception as e:
        return str(e)



@app.route('/categoria_add', methods=["POST"])
def categoria_add():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        category_name = request.form['category_name']
        super_category_name = request.form['super_category']
        category_type = request.form['category_type']
        queries = []

        query = "INSERT INTO categoria VALUES (%s)"
        data = (category_name,)
        cursor.execute(query, data)
        queries.append(cursor.mogrify(query, data).decode('utf-8'))

        if super_category_name != "":
            query = "INSERT INTO tem_outra (super_categoria, categoria) VALUES (%s, %s)"
            data = (super_category_name, category_name)
            cursor.execute(query, data)
            queries.append(cursor.mogrify(query, data).decode('utf-8'))
        
        if category_type == "categoria_simples":
            query = "INSERT INTO categoria_simples VALUES (%s)"
        else:
            query = "INSERT INTO super_categoria VALUES (%s)"
        
        data = (category_name,)
        cursor.execute(query, data)
        queries.append(cursor.mogrify(query, data).decode('utf-8'))

        dbConn.commit()

        return str(queries)

    except Exception as e:
        return str(e)
        
    finally:
        if cursor:
            cursor.close()
        if dbConn:
            dbConn.close()





@app.route('/retalhistas')
def retalhistas_list():
        
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute("SELECT * FROM retalhista")
        return render_template('retalhistas_list.html', cursor = cursor, params = request.args)

    except Exception as e:
        return str(e)
        
    finally:
        if cursor:
            cursor.close()
        if dbConn:
            dbConn.close()


@app.route('/retalhista_adicionar')
def retalhista_adicionar():
    try:
        return render_template("retalhista_adicionar.html")
    except Exception as e:
        return str(e)


@app.route('/retalhista_add', methods=["POST"])
def retalhista_add():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        retalhista_name = request.form['name']
        retalhista_tin = request.form['tin']

        query = "INSERT INTO retalhista VALUES (%s, %s)"
        data = (retalhista_tin, retalhista_name)
        cursor.execute(query, data)

        dbConn.commit()

        return str(cursor.mogrify(query, data).decode('utf-8'))

    except Exception as e:
        return str(e)
        
    finally:
        if cursor:
            cursor.close()
        if dbConn:
            dbConn.close()



@app.route('/retalhista_remove', methods=["POST"])
def retalhista_remove():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        category_name = request.form['category_name']
        queries = []

        query = "DELETE FROM tem_outra WHERE super_categoria = %s or categoria = %s"
        data = (category_name, category_name)
        cursor.execute(query, data)
        queries.append(cursor.mogrify(query, data).decode('utf-8'))

        query = "DELETE FROM categoria_simples WHERE nome = %s"
        data = (category_name,)
        cursor.execute(query, data)
        queries.append(cursor.mogrify(query, data).decode('utf-8'))

        query = "DELETE FROM super_categoria WHERE nome = %s"
        data = (category_name,)
        cursor.execute(query, data)
        queries.append(cursor.mogrify(query, data).decode('utf-8'))

        query = "DELETE FROM categoria WHERE nome = %s"
        data = (category_name,)
        cursor.execute(query, data)
        queries.append(cursor.mogrify(query, data).decode('utf-8'))

        dbConn.commit()

        return str(queries)

    except Exception as e:
        return str(e)
        
    finally:
        if cursor:
            cursor.close()
        if dbConn:
            dbConn.close()





CGIHandler().run(app)



#!/usr/bin/python3

from inspect import Traceback
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
    try:
        return render_template("index.html")
    except Exception as e:
        return str(e)


@app.route('/produtos')
def produtos_list():

    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute("SELECT * FROM produto")
        return render_template('produtos.html', cursor = cursor)

    except Exception as e:
        return str(e)
        
    finally:
        if cursor:
            cursor.close()
        if dbConn:
            dbConn.close()


@app.route('/categorias')
def categorias_list():


    dbConn = None
    cursor1 = None
    cursor2 = []
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor1 = dbConn.cursor(name = 'cursor1', cursor_factory=psycopg2.extras.DictCursor)
        cursor2 = dbConn.cursor(name = 'cursor2', cursor_factory=psycopg2.extras.DictCursor)


        if request.args.get('super_category'):
            query = "SELECT categoria FROM tem_outra WHERE super_categoria = %s AND categoria IN ( SELECT nome FROM super_categoria )"
            data = (request.args.get('super_category'),)
            cursor1.execute(query, data)

            query = "SELECT categoria FROM tem_outra WHERE super_categoria = %s AND categoria IN ( SELECT nome FROM categoria_simples )"
            data = (request.args.get('super_category'),)
            cursor2.execute(query, data)

        
        else:
            cursor1.execute("SELECT * FROM super_categoria")
            cursor2.execute("SELECT * FROM categoria_simples")

        return render_template('categorias_list.html', cursor = cursor1, cursor2 = cursor2, params = request.args)

    except Exception as e:
        return str(e)
        
    finally:
        if cursor1:
            cursor1.close()
        if cursor2 != []:
            cursor2.close()
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

        query = "DELETE FROM produto WHERE ean IN ( SELECT ean FROM tem_categoria WHERE nome = %s )"
        data = (category_name,)
        cursor.execute(query, data)
        queries.append(cursor.mogrify(query, data).decode('utf-8'))

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

        query = "DELETE FROM tem_categoria WHERE nome = %s"
        data = (category_name,)
        cursor.execute(query, data)
        queries.append(cursor.mogrify(query, data).decode('utf-8'))

        query = "DELETE FROM planograma WHERE loc = %s"
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
        queries = []

        retalhista_tin = request.form['tin']

        query = "DELETE FROM responsavel_por WHERE tin = %s"
        data = (retalhista_tin,)
        cursor.execute(query, data)
        queries.append(cursor.mogrify(query, data).decode('utf-8'))

        query = "DELETE FROM evento_reposicao WHERE tin = %s"
        data = (retalhista_tin,)
        cursor.execute(query, data)
        queries.append(cursor.mogrify(query, data).decode('utf-8'))

        query = "DELETE FROM retalhista WHERE tin = %s"
        data = (retalhista_tin,)
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



@app.route('/ivms')
def ivms_list():
        
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute("SELECT * FROM ivm")
        return render_template('ivms_list.html', cursor = cursor, params = request.args)

    except Exception as e:
        return str(e)
        
    finally:
        if cursor:
            cursor.close()
        if dbConn:
            dbConn.close()



@app.route('/eventos_reposicao')
def eventos_reposicao_list():
        
    dbConn = None
    cursor1 = None
    cursor2 = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor1 = dbConn.cursor(name = 'cursor1', cursor_factory=psycopg2.extras.DictCursor)
        cursor2 = dbConn.cursor(name = 'cursor2', cursor_factory=psycopg2.extras.DictCursor)


        if request.args.get('num_serie') and request.args.get('fabricante'):
            query = "SELECT * FROM evento_reposicao WHERE num_serie = %s and fabricante = %s"
            data = (request.args.get('num_serie'), request.args.get('fabricante'))
            cursor1.execute(query, data)


            query = "SELECT nome, unidades FROM tem_categoria JOIN evento_reposicao ON tem_categoria.ean = evento_reposicao.ean WHERE num_serie = %s AND fabricante = %s;"
            data = (request.args.get('num_serie'), request.args.get('fabricante'))
            cursor2.execute(query, data)

        
        else:
            cursor1.execute("SELECT * FROM evento_reposicao")

        return render_template('eventos_reposicao_list.html', cursor = cursor1, categories = cursor2, params = request.args)

    except Exception as e:
        return str(e)
        
    finally:
        if cursor1:
            cursor1.close()
        if cursor2:
            cursor2.close()
        if dbConn:
            dbConn.close()



CGIHandler().run(app)



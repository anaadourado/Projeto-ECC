import PySimpleGUI as sg
import psycopg2

def limpar():
    window['-RA-'].update('')
    window['-Nome_aluno-'].update('')
    window['-End_aluno-'].update('')
    window['-Tel_aluno-'].update('')
    window['-CPF_aluno-'].update('')
    window['-RG_aluno-'].update('')
    window['-Sexo_aluno-M'].update(True)
    window['-Data_nasc_aluno-'].update('')
    window['-Etnia_aluno-'].update('')

def atualiza():
    if len(lista) == 0:
        limpar()
    else:
        window['-RA-'].update(lista[indice][0])
        window['-Nome_aluno-'].update(lista[indice][1])
        window['-End_aluno-'].update(lista[indice][2])
        window['-Tel_aluno-'].update(lista[indice][3])
        window['-CPF_aluno-'].update(lista[indice][4])
        window['-RG_aluno-'].update(lista[indice][5])
        if lista[indice][6] == 'M':
            window['-Sexo_aluno-M'].update(True)
        else:
            window['-Sexo_aluno-F'].update(True)
        window['-Data_nasc_aluno-'].update(lista[indice][7])
        window['-Etnia_aluno-'].update(lista[indice][8])

def todos():
    global indice
    global lista
    resposta = []
    with con:
        with con.cursor() as cursor:
            cursor.execute("SELECT * FROM Aluno;")
            resposta = cursor.fetchall()
    lista.clear()
    for i in range(len(resposta)):
        lista.append(list(resposta[i]))
    sg.popup('Quantidade de registros: ' + str(len(resposta)))
    indice = 0
    atualiza()

def cadastrar_aluno(values):
    with con:
        with con.cursor() as cursor:
            cursor.execute("INSERT INTO Aluno (RA, Nome_aluno, End_aluno, Tel_aluno, CPF_aluno, RG_aluno, Sexo_aluno, Data_nasc_aluno, Etnia_aluno) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);",
                           (values['-RA-'], values['-Nome_aluno-'], values['-End_aluno-'], values['-Tel_aluno-'], values['-CPF_aluno-'], values['-RG_aluno-'], ('M' if values['-Sexo_aluno-M'] else 'F'), values['-Data_nasc_aluno-'], values['-Etnia_aluno-']))
    limpar()

# Initialize DB
con = psycopg2.connect(
    host="localhost", database="ECClindo", user="postgres", password="123456"
)

cursor = con.cursor()
cursor.execute("SELECT * FROM Aluno;")
resposta = cursor.fetchall()

with con:
    with con.cursor() as cursor:
        cursor.execute("""DROP TABLE IF EXISTS Aluno cascade;

create table Aluno(

    RA CHAR(8) NOT NULL PRIMARY KEY,
    Nome_aluno varchar(30) not null,
    End_aluno varchar(50) not null,
    Tel_aluno CHAR(13)  not null,
    CPF_aluno char(14) not null,
    RG_aluno char(12) not null,
    Sexo_aluno CHAR(1) NOT NULL CHECK (Sexo_aluno IN ('M','F')),
    Data_nasc_aluno date not null,
    Etnia_aluno CHAR (15) NOT NULL
        CHECK (Etnia_aluno IN ('Branco','Preto','Amarelo','Pardo','Indígena' )));""")

layout1 = [
    [sg.Image('logo.png', size=(5, 10))],
    [sg.Text("RA:", size=(8, 1)), sg.InputText(size=(6, 1), key="-RA-", focus=False)],
    [sg.Text("Nome:", size=(8, 1)), sg.InputText(size=(40, 1), key="-Nome_aluno-", focus=True)],
    [sg.Text("Endereço:", size=(8, 1)), sg.InputText(size=(40, 1), key="-End_aluno-")],
    [sg.Text("Celular:", size=(8, 1)), sg.InputText(size=(40, 1), key="-Tel_aluno-")],
    [sg.Text("CPF:", size=(8, 1)), sg.InputText(size=(40, 1), key="-CPF_aluno-")],
    [sg.Text("RG:", size=(8, 1)), sg.InputText(size=(40, 1), key="-RG_aluno-")],
    [sg.Text("Gênero:", size=(8, 1)), sg.Radio('Masculino', 'GRUPO1', default=False, key="-Sexo_aluno-M"), sg.Radio('Feminino', 'GRUPO1', default=True, key="-Sexo_aluno-F")],
    [sg.Text("Data. Nasc:", size=(8, 1)), sg.InputText(size=(40, 1), key="-Data_nasc_aluno-")],
    [sg.Text("Etnia:", size=(8, 1)), sg.InputText(size=(40, 1), key="-Etnia_aluno-")],
    [sg.Button('Limpar', size=(8, 1), key="-LIMPAR-"), sg.Button('Cadastrar', size=(8, 1), key="-CADASTRAR-"),
     sg.Button('Atualizar', size=(8, 1), key="-ATUALIZAR-"), sg.Button('Remover', size=(8, 1), key="-REMOVER-")],
]

window = sg.Window("Aluno", layout1, use_default_focus=False)

# Run the Event Loop
while True:
    event, values = window.read()
    if event == sg.WIN_CLOSED:
        break
    elif event == "-LIMPAR-":
        limpar()
    elif event == "-CADASTRAR-":
        cadastrar_aluno(values)
    elif event == "-ATUALIZAR-":
        with con:
            with con.cursor() as cursor:
                cursor.execute("UPDATE Aluno SET RA = %s, Nome_aluno = %s, End_aluno = %s, Tel_aluno = %s, CPF_aluno = %s, RG_aluno = %s, Sexo_aluno = %s, Data_nasc_aluno = %s, Etnia_aluno = %s WHERE RA = %s;",
                               (values['-RA-'], values['-Nome_aluno-'], values['-End_aluno-'], values['-Tel_aluno-'], values['-CPF_aluno-'], values['-RG_aluno-'], ('M' if values['-Sexo_aluno-M'] else 'F'), values['-Data_nasc_aluno-'], values['-Etnia_aluno-'], list[indice][0]))
        list[indice] = [values['-RA-'], values['-Nome_aluno-'], values['-End_aluno-'], values['-Tel_aluno-'], values['-CPF_aluno-'], values['-RG_aluno-'], ('M' if values['-Sexo_aluno-M'] else 'F'), values['-Data_nasc_aluno-'], values['-Etnia_aluno-']]
    elif event == "-REMOVER-":
        with con:
            with con.cursor() as cursor:
                cursor.execute("DELETE FROM Aluno WHERE RA = %s;",
                               (values['-RA-'],))
        list.pop(indice)
        indice -= 1
        atualiza()
    elif event == "-PROCURAR-":
        with con:
            with con.cursor() as cursor:
                cursor.execute("SELECT * FROM Aluno WHERE Nome_aluno LIKE %s;",
                               ('%' + values['-Nome_aluno-'] + '%',))
                resposta = cursor.fetchall()
                list.clear()
                for i in range(len(resposta)):
                    list.append(list(resposta[i]))
                sg.popup('Quantidade de registros: ' + str(len(resposta)))
                indice = 0
                atualiza()
    elif event == "-TODOS-":
        todos()
    elif event == "->>-":
        index += 1
        if index >= len(list):
            index = len(list)-1
        atualiza()
    elif event == "-<<-":
        index -= 1
        if index <= 0:
            index = 0
        atualiza()

window.close()

# Fazer as mudanças para a base persistente
con.commit()

# Fechar a comunicação com o banco de dados
con.close()






































































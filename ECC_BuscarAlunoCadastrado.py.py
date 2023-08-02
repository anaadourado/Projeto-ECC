import psycopg2
import PySimpleGUI as sg
import re

sg.theme('Reddit')

def cadastrar_aluno(values, con):
    cursor = con.cursor()
    cursor.execute("Select * from Aluno WHERE RA = %s;", (values['RA'],))
    aluno = cursor.fetchone()
    
    if aluno:
        sg.popup('RA já cadastrado. Informações existentes:')
        sg.popup(f'Nome: {aluno[1]}\nEndereço: {aluno[2]}\nCelular: {aluno[3]}\nCPF: {aluno[4]}\nRG: {aluno[5]}\nSexo: {aluno[6]}\nData de Nascimento: {aluno[7]}\nEtnia: {aluno[8]}')
    else:
        with con:
            with con.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO Aluno (RA, Nome_aluno, End_aluno, Tel_aluno, CPF_aluno, RG_aluno, Sexo_aluno, Data_nasc_aluno, Etnia_aluno) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);",
                    (values['RA'], values['-Nome_aluno-'], values['-End_aluno-'], values['-Tel_aluno-'],
                     values['-CPF_aluno-'], values['-RG_aluno-'], ('M' if values['-Sexo_aluno-'] else 'F'),
                     values['-Data_nasc_aluno-'], values['-Etnia_aluno-'])
                )
        sg.popup('Aluno cadastrado com sucesso')

def limpar(window):
    window['-RA-'].update('')
    window['-Nome_aluno-'].update('')
    window['-End_aluno-'].update('')
    window['-Tel_aluno-'].update('')
    window['-CPF_aluno-'].update('')
    window['-RG_aluno-'].update('')
    window['-Sexo_aluno-'].update(True)
    window['-Data_nasc_aluno-'].update('')
    window['-Etnia_aluno-'].update('')

def atualiza(window, lista, indice):
    if len(lista) == 0:
        limpar(window)
    else:
        window['-RA-'].update(lista[indice][0])
        window['-Nome_aluno-'].update(lista[indice][1])
        window['-End_aluno-'].update(lista[indice][2])
        window['-Tel_aluno-'].update(lista[indice][3])
        window['-CPF_aluno-'].update(lista[indice][4])
        window['-RG_aluno-'].update(lista[indice][5])
        if lista[indice][6]:
            window['-Sexo_aluno-'].update(True)
        else:
            window['-Sexo_aluno-'].update(False)
        window['-Data_nasc_aluno-'].update(lista[indice][7])
        window['-Etnia_aluno-'].update(lista[indice][8])

def todos(window, con):
    global indice
    global lista
    resposta = []
   
    with con:
        with con.cursor() as cursor:
            cursor.execute("Select * from Aluno;")
            resposta = cursor.fetchall()
    lista.clear()
    for i in range(len(resposta)):
        lista.append(list(resposta[i]))
    sg.popup('Quantidade de registros: ' + str(len(resposta)))
    if len(lista) == 0:
        limpar(window)
    else:
        indice = 0
        atualiza(window, lista, indice)

def format_date(text):
    pattern = r'(\d{2})/(\d{2})/(\d{4})'
    match = re.search(pattern, text)
    if match:
        day = match.group(1)
        month = match.group(2)
        year = match.group(3)
        return f"{year}-{month}-{day}"
    return text

def main():
    con = psycopg2.connect(
        host="localhost",
        database="ECClindo",
        user="postgres",
        password="123456"
    )
    
    # Initialize DB
con = psycopg2.connect(
    host="localhost", database="ECClindo", user="postgres", password="123456"
)

cursor = con.cursor()
cursor.execute("Select * from Aluno;")
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
    
    layout = [
        [sg.Text('RA', size=(15, 1)), sg.Input(key='-RA-')],
        [sg.Text('Nome do Aluno', size=(15, 1)), sg.Input(key='-Nome_aluno-')],
        [sg.Text('Endereço', size=(15, 1)), sg.Input(key='-End_aluno-')],
        [sg.Text('Telefone', size=(15, 1)), sg.Input(key='-Tel_aluno-')],
        [sg.Text('CPF', size=(15, 1)), sg.Input(key='-CPF_aluno-')],
        [sg.Text('RG', size=(15, 1)), sg.Input(key='-RG_aluno-')],
        [sg.Text('Sexo', size=(15, 1)), sg.Radio('Masculino', 'Sexo', default=True, key='-Sexo_aluno-'),
         sg.Radio('Feminino', 'Sexo', key='-Sexo_aluno-')],
        [sg.Text('Data de Nascimento', size=(15, 1)), sg.Input(key='-Data_nasc_aluno-')],
        [sg.Text('Etnia', size=(15, 1)), sg.Input(key='-Etnia_aluno-')],
        [sg.Button('Cadastrar', size=(10, 1)), sg.Button('Limpar', size=(10, 1)), sg.Button('Anterior', size=(10, 1)),
         sg.Button('Próximo', size=(10, 1)), sg.Button('Todos', size=(10, 1)), sg.Button('Sair', size=(10, 1))]
    ]

    window = sg.Window('Cadastro de Alunos', layout)

    while True:
        event, values = window.read()

        if event == sg.WINDOW_CLOSED or event == 'Sair':
            break

        if event == 'Cadastrar':
            values['-Data_nasc_aluno-'] = format_date(values['-Data_nasc_aluno-'])
            cadastrar_aluno(values, con)

        if event == 'Limpar':
            limpar(window)

        if event == 'Anterior':
            if len(list) > 0:
                if indice > 0:
                    indice -= 1
                    atualiza(window, list, indice)

        if event == 'Próximo':
            if len(list) > 0:
                if indice < len(list) - 1:
                    indice += 1
                    atualiza(window, list, indice)

        if event == 'Todos':
            todos(window, con)

    window.close()

if __name__ == '__main__':
    main()


# Conexão com o banco de dados
con = psycopg2.connect(
    host="localhost", database="ECClindo", user="postgres", password="01234"
)




#window.close()




# Fazer as mudanças para a base persistente

con.commit()




# Fechar a comunicação com o servidor


con.close()
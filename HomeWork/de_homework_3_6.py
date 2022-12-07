from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python_operator import PythonOperator

import random
from random import sample
import numpy as np


def hello() :
    print ("Airflow_hello_hello_hello")

def generate_two_digits():
    """ 12.a.      Создайте еще один PythonOperator,
    который генерирует два произвольных числа и печатает их.
    Добавьте вызов нового оператора в конец вашего pipeline с помощью >>.
    """
    x = random.randint(1, 100)
    y = random.randint(1, 100)
    print (f"Первое сгенеренное число такое {x}, а второе такое: {y}")

def create_textfile_with_two_digits(tmp_file):
    """12.c.      Если запуск произошел успешно,
    попробуйте изменить логику вашего Python-оператора следующим образом –
    сгенерированные числа должны записываться в текстовый файл – через пробел.
    При этом должно соблюдаться условие, что каждые новые два числа должны
    записываться с новой строки не затирая предыдущие.
    """

    # создаем список с элементом случайности
    digits_list = sample(range(1, 100), random.randint(1, 20))

    # разбиваем на пары
    couple_list = [digits_list[i:(i+2)] for i in range(0, len(digits_list), 2)]
    print(f"Целиком {couple_list}")

    # записываем пары цифр в файл построчно
    with open(tmp_file, "w") as f:
        for i in couple_list:
            f.write(f'{" ".join([str(elem_i) for elem_i in i])}\n')


def load_calculat_save(tmp_file):
    """ 12.d.      Создайте новый оператор, который подключается к файлу и
        вычисляет сумму всех чисел из первой колонки, затем сумму всех чисел
        из второй колонки и рассчитывает разность полученных сумм.
        Вычисленную разность необходимо записать в конец того же файла,
        не затирая его содержимого.
    """

    # загрузка данных, расчет суммы колонок и их разности
    with open(tmp_file, "r") as f:
        # считываем данные из файла
        lines_list = f.readlines()
        # создаем переменные для подсчета суммы чисел и з первой и второй колонок
        sum_first_col = 0
        sum_second_col = 0
        for line in lines_list:
            two_digits_list = line.split()
            sum_first_col += int(two_digits_list[0])
            sum_second_col += int(two_digits_list[1] if two_digits_list[1] else 0)

        different = str(sum_first_col - sum_second_col)

    # записываем разность в коней файла
    with open(tmp_file, "a") as f:
        f.write(f"Разница сум первой и второй колонок: {different}")

    #12.e.      Измените еще раз логику вашего оператора из пунктов 12.а – 12.с.
    # При каждой новой записи произвольных чисел в конец файла,
    # вычисленная сумма на шаге 12.d должна затираться.

    # !!! Постановка вопроса не совсем ясна и противоречива.
    # Если имелось ввиду записать разность стерев все текущие данные, то
    # в функции open выбираем параметр "w", если имеется ввиду просто обнулить переменные
    # с суммами , то обнуляем так
    sum_first_col = 0
    sum_second_col = 0

# A DAG represents a workflow, a collection of tasks

with DAG(dag_id="first_day",
         start_date=datetime.now(),
         schedule="* * * * *",
         max_active_runs=5) as dag:

    # Tasks are represented as operators
    bash_task = BashOperator(task_id="hello", bash_command="echo bash_hello_hello")

    python_task = PythonOperator(task_id="world", python_callable = hello)

    python_two_digits = PythonOperator(task_id="two_digits",
                                     python_callable = generate_two_digits)

    python_two_digits_to_textfile = PythonOperator(task_id="create_file",
                                     python_callable=create_textfile_with_two_digits,
                                     op_kwargs={'tmp_file': '//tmp//two_digitdfile.txt'})

    python_read_textfile = PythonOperator(task_id="load_data",
                                     python_callable=load_calculat_save,
                                     op_kwargs={'tmp_file': '//tmp//two_digitdfile.txt'})



    # Set dependencies between tasks
    bash_task >> python_task >> python_two_digits >> python_two_digits_to_textfile \
    >> python_read_textfile
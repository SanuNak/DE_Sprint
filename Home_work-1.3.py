import requests as req
from bs4 import BeautifulSoup
import json
import tqdm
import time

def parsing_site_hh():
    data = {
        "data": []
    }

    sess = req.Session()
    sess.headers.update({
        'location': 'https://hh.ru/',
        'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
        'accept-encoding': 'gzip, deflate, br',
        'accept-language': 'ru',
        'cache-control': 'no-cache',
        'pragma': 'no-cache',
        'sec-ch-ua': '".Not/A)Brand";v="99", "Google Chrome";v="103", "Chromium";v="103"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"Linux"',
        'sec-fetch-dest': 'document',
        'sec-fetch-mode': 'navigate',
        'sec-fetch-site': 'none',
        'sec-fetch-user': '?1',
        'upgrade-insecure-requests': '1',
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.5112.114 YaBrowser/22.9.1.1095 Yowser/2.5 Safari/537.36'
    })

    for page in range(1, 10):
        url = f"https://hh.ru/search/vacancy?area=113&search_field=name&search_field=company_name&search_field=description&text=python+разработчик&clusters=true&ored_clusters=true&enable_snippets=true&page={page}&hhtmFrom=vacancy_search_list"
        response = sess.get(url)
        soup = BeautifulSoup(response.text, 'lxml')
        tags = soup.find_all(attrs={"data-qa": "serp-item__title"})
        for iter in tqdm.tqdm(tags):
            time.sleep(0.5)
            #
            url_object = iter.attrs["href"]
            resp_object = sess.get(url_object)
            soup_object = BeautifulSoup(resp_object.text, "lxml")

            if soup_object.find(attrs={"data-qa": "vacancy-salary"}).find(
                    attrs={"data-qa": "vacancy-salary-compensation-type-net"}):
                tag_price = soup_object.find(attrs={"data-qa": "vacancy-salary"}).find(
                    attrs={"data-qa": "vacancy-salary-compensation-type-net"}).text
            else:
                tag_price = None

            if soup_object.find(attrs={"class":"vacancy-description-list-item"}):
                tag_work_experience = soup_object.find(
                    attrs={"data-qa":"vacancy-experience"}).text
            else:
                tag_region = None

            if soup_object.find(attrs={"data-qa": "vacancy-view-link-location"}):
                tag_region = soup_object.find(
                    attrs={"data-qa": "vacancy-view-link-location"}).text
            else:
                tag_region = None

            data["data"].append(
                {"title": iter.text,
                 "work_experience": tag_work_experience,
                 "salary": tag_price,
                 "region": tag_region})

            with open("data.json", "w") as file:
                json.dump(data, file, ensure_ascii=False)

def checking_palindrom(str):
    str = str.replace(" ", "", ).lower()

    if str == str[::-1]:
        print("Текст - палиндром!")
        return True
    else:
        print("Текст - НЕпалиндром!")
        return None

def get_rome_digit(digit):

    dictionary_numbers = {
        1: "I",
        5: "V",
        9: "IX",
        10: "X",
        40: "XL",
        50: "L",
        90: "XC",
        100: "C",
        400: "CD",
        500: "D",
        900: "CM",
        1000: "M"
    }
    rome_digit = ""
    len_digit = len(str(digit))
    digit_copy = digit

    def _definition_letters(category, digit):
        count_zero = '0'*(category-1)
        if digit == 0:
            return "", 0

        if category == 4:
            _rank = int(f"1{count_zero}")
        elif category == 3:
            if digit >= 900:
                _rank = int(f"9{count_zero}")
            elif digit >= 500:
                _rank = int(f"5{count_zero}")
            elif digit >= 400:
                _rank = int(f"4{count_zero}")
            elif digit >= 100:
                _rank = int(f"1{count_zero}")
        elif category == 2:
            if digit >= 90:
                _rank = int(f"9{count_zero}")
            elif digit >= 50:
                _rank = int(f"5{count_zero}")
            elif digit >= 40:
                _rank = int(f"4{count_zero}")
            else:
                _rank = int(f"1{count_zero}")
        elif category == 1:
            if digit >= 9:
                _rank = int(f"9{count_zero}")
            elif digit >= 5:
                _rank = int(f"5{count_zero}")
            elif digit >= 1:
                _rank = int(f"1{count_zero}")

        _literal = dictionary_numbers[_rank] * (digit // _rank)
        _digit = digit % _rank
        return _literal, _digit

    for category in range(len_digit, 0, -1):
        literals, digit_copy = _definition_letters(category, digit_copy)
        rome_digit += literals

        if digit_copy == 0:
            break

        count_zero = '0' * (category - 1)
        if digit_copy >= int(f"1{count_zero}"):
            literals, digit_copy = _definition_letters(category, digit_copy)
            rome_digit += literals

    print(rome_digit)

def checking_brackets(brackets):
    split_brackets = list(brackets)

    bracket_dict = {
        "(": ")",
        "{": "}",
        "[": "]",
        ")": "(",
        "]": "[",
        "}": "{",
    }
    while len(split_brackets) > 0:
        bracket = split_brackets[0]
        anty_brecket = bracket_dict[bracket]

        split_brackets.remove(bracket)
        try:
            split_brackets.remove(anty_brecket)
            if split_brackets == []:
                print("Для каждой скобки есть пара")
                return True

        except ValueError:
            print(f"Как минимум для скобки '{bracket}' нет пары")
            return False

def multipl_binary_numbers(binary_digit_list):
    binary_digit_1, binary_digit_2 = binary_digit_list

    Multiplication = int(binary_digit_1, 2) * int(binary_digit_2, 2)
    binaryMul = bin(Multiplication)

    print(f"Результат произведения следующий : {binaryMul[2:]}")


if __name__ == "__main__":
    parsing_site_hh()
    # checking_palindrom(input("Введите слово : ") or "Коток")
    # get_rome_digit(int(input("\nВведите число до 2000 : ")) or 1945)
    # checking_brackets(input("\nВведите набор скобок : ") or "{]")
    # multipl_binary_numbers(input("\nВведите два бинарных числа через пробел : ").split() or ["111", "101"])

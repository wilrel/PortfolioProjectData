#Scrapping dari Booking.com @wilrel

import requests
from bs4 import BeautifulSoup
import lxml
import csv
import time
import random

url_text = 'https://www.booking.com/searchresults.html?ss=Ubud%2C+Indonesia&efdco=1&label=gen173nr-1FCAEoggI46AdIM1gEaGiIAQGYATG4ARfIAQzYAQHoAQH4AQKIAgGoAgO4Aorf8r8GwAIB0gIkNTg1NTE1YjYtMTlkMi00ODhhLWI1ZWQtZmYzZTg2MGIxY2Nl2AIF4AIB&aid=304142&lang=en-us&sb=1&src_elem=sb&src=index&dest_id=-2701757&dest_type=city&checkin=2025-05-01&checkout=2025-05-02&group_adults=2&no_rooms=1&group_children=0'

header = {'User-Agent' : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0'}

response = requests.get(url_text, headers=header)

if response.status_code == 200:
    print("Berhasil Konek Ke Website")
    html_content = response.text

    #Creating Soup
    soup = BeautifulSoup(html_content, 'lxml')
    # print(soup.prettify())

    #Main Container
    hotel_divs = soup.find_all('div', role="listitem")

    with open('hotel_data.csv', 'w', encoding='utf-8') as file_csv:
        writer = csv.writer(file_csv)

    #     #adding header
        writer.writerow(['hotel_name', 'locality', 'price', 'rating', 'score', 'review', 'link'])

    #iterasi
    for hotel in hotel_divs:
        hotel_name = hotel.find('div', class_="f6431b446c a15b38c233").text.strip()
        location = hotel.find('span', class_="aee5343fdb def9bc142a").text.strip()

        # #price
        price = hotel.find('span', class_="f6431b446c fbfd7c1165 e84eb96b1f").text.strip()
        rating = hotel.find('div', class_="a3b8729ab1 e6208ee469 cb2cbb3ccb").text.strip()
        score = hotel.find('div', class_="a3b8729ab1 d86cee9b25").text.strip().split(' ')[-1]

        review = hotel.find('div', class_="abf093bdfe f45d8e4c32 d935416c47").text.strip()
        
        #getting link
        link = hotel.find('a', href=True).get('href')


        #saving the file csv
        writer.writerow([hotel_name, location, price, rating, score, review, link])

        # print(hotel_name)
        # print(location)
        # print(price)
        # print(rating)
        # print(score)
        # print(review)
        # print(link)
        # print('')

# else:
#     print(f"Gagal Terhubung! {response.status_code}")

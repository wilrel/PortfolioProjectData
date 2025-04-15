import requests
from bs4 import BeautifulSoup
import csv
import time
import random

url_text = 'https://www.booking.com/searchresults.html?ss=Ubud%2C+Indonesia&efdco=1&label=gen173nr-1FCAEoggI46AdIM1gEaGiIAQGYATG4ARfIAQzYAQHoAQH4AQKIAgGoAgO4Aorf8r8GwAIB0gIkNTg1NTE1YjYtMTlkMi00ODhhLWI1ZWQtZmYzZTg2MGIxY2Nl2AIF4AIB&aid=304142&lang=en-us&sb=1&src_elem=sb&src=index&dest_id=-2701757&dest_type=city&checkin=2025-05-01&checkout=2025-05-02&group_adults=2&no_rooms=1&group_children=0'
def web_scrapper2(web_url, f_name):
    # greetings
    print("Thank you sharing the url and file name!\n⏳\nReading the content!")
    
    num = random.randint(3, 7)
    
    # processing
    time.sleep(num)
    header = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0'}

    response = requests.get(web_url, headers=header)

    if response.status_code == 200:
        print("Berhasil Konek Ke Website")
        html_content = response.text
        soup = BeautifulSoup(html_content, 'lxml')
    
        # Updated selector - Booking.com frequently changes their class names
        hotel_divs = soup.find_all('div', {'data-testid': 'property-card'})
    
        # Open the file and keep it open for all writes
        with open('hotel_data.csv', 'w', newline='', encoding='utf-8') as file_csv:
            writer = csv.writer(file_csv)
            writer.writerow(['hotel_name', 'locality', 'price', 'rating', 'score', 'review', 'link'])
        
            for hotel in hotel_divs:
                try:
                    # More reliable selectors using data-testid
                    hotel_name = hotel.find('div', {'data-testid': 'title'}).text.strip()
                    location = hotel.find('span', {'data-testid': 'address'}).text.strip()
                    price = hotel.find('span', {'data-testid': 'price-and-discounted-price'}).text.replace(' ', '')
                
                    rating = hotel.find('div', class_="a3b8729ab1 e6208ee469 cb2cbb3ccb").text.strip()
                    score = hotel.find('div', class_="a3b8729ab1 d86cee9b25").text.strip().split(' ')[-1]

                    review = hotel.find('div', class_="abf093bdfe f45d8e4c32 d935416c47").text.strip()
                
                    link_element = hotel.find('a', {'data-testid': 'title-link'})
                    link = link_element['href'] if link_element else "N/A"
                    if link != "N/A" and not link.startswith('http'):
                        link = f"https://www.booking.com{link}"
                
                    writer.writerow([hotel_name, location, price, rating, score, review, link])
                    print(f"Saved: {hotel_name}")
                
                    # Add delay to avoid being blocked
                    time.sleep(random.uniform(0.5, 1.5))
                
                except Exception as e:
                    print(f"Error processing hotel: {e}")
                    continue
                
        print("Data berhasil disimpan ke hotel_data.csv")
    else:
        print(f"Gagal Terhubung! {response.status_code}")

if __name__ == '__main__':

    url = input("Please enter url! :")
    fn = input('Please give file name! :')

    # calling the function
    web_scrapper2(url, fn)
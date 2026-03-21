import json
import os

def convert():
    with open('/tmp/kjv.json', 'r') as f:
        data = json.load(f)
    
    books = data['books']
    converted_books = []
    
    for i, book in enumerate(books):
        book_id = i + 1
        testament = "Old" if book_id <= 39 else "New"
        
        converted_book = {
            "book_id": book_id,
            "book_name": book['name'],
            "abbreviation": "",
            "testament": testament,
            "chapters": []
        }
        
        for chapter in book['chapters']:
            converted_chapter = {
                "chapter": chapter['chapter'],
                "verses": []
            }
            for verse in chapter['verses']:
                converted_chapter['verses'].append({
                    "verse": verse['verse'],
                    "text": verse['text']
                })
            converted_book['chapters'].append(converted_chapter)
            
        converted_books.append(converted_book)
        
    with open('/home/nati/Desktop/Projects/bible/assets/bible/english_kjv.json', 'w') as f:
        json.dump(converted_books, f, ensure_ascii=False, indent=2)

if __name__ == "__main__":
    convert()

## Тестовое задание для компании Pact

### Описание

Данное задание включает в себя рефакторинг класса Users::Create, использование гемов ActiveInteraction, а также улучшение структуры базы данных и тестирования.

### Изменения

1. **Рефакторинг класса Users::Create**
   - Использован гем ActiveInteraction для упрощения создания пользователей и управления их данными.

2. **Переименование таблицы в базе данных**
  - Возможны два варианта:
    - **Вариант A**: Переименовать таблицу skils в skills.

      Создадим миграцию и далее используем в коде корректное название (переименовываем все упоминания Skil -> Skill)
      ```ruby
        rails g migration RenameSkilsToSkills

        class RenameSkilsToSkills < ActiveRecord::Migration
          def change
            rename_table :skils, :skills
          end
        end
      ```

    - **Вариант В**: Оставить Skil как есть, но явно указывать class_name: 'Skil' в модели User и дальше по коду, что может вызвать путаницу в будущем.

3. **Исправлены связи на has_and_belongs_to_many для исключения избыточности данных в бд**.

4. **Запуск и тестирование** 
- для запуска используйте:
  ```ruby
  bundle install
  
  rails s
  ```

- для создания бд и тестовых данных используйте (db:create, db:migrate, db:seed):
  ```ruby
  make db
  ```
- для проверок используйте (rspec, rubocop, bundle audit, bundle-leak):
  ```ruby
  make check
  ```
- Имеется возможность добавить юзера через curl:
  ```html
  curl -X POST http://localhost:3000/users \
    -H "Content-Type: application/json" \
    -d '{
    "user": {
      "name": "Sam",
      "patronymic": "Doe",
      "surname": "Smith",
      "email": "sams432.smith@example.com",
      "age": 30,
      "nationality": "Country",
      "country": "Country",
      "gender": "male",
      "interests": ["Programming", "Sports"],
      "skills": "Ruby,Rails,JavaScript"
      }
    }'
  ```
 5. **Написаны тесты rspec.**
    
      Запуск тестов
      
     ```ruby
     make rspec
     ```

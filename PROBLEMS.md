## Введение
В первую очередь всегда проверяйте данную подборку частых проблем. Если ваша проблема не подходит ни под один кейс, создайте репорт о проблеме [здесь](https://github.com/romanespit/Fire-Department-Helper/issues/new). Если проблема будет описана здесь, отвечать на репорт не буду, просто закрою его. 

## Частые проблемы
### Крашит/падает скрипт на вкладке Биндер при выборе старых биндов
Решение в репорте [#9](https://github.com/romanespit/Fire-Department-Helper/issues/9)
### При попытке назначить клавишу в биндере, крашит скрипт
Значит при установке не перенесли папку lib в moonloader. Повторно прочитайте файл **Установка.txt** в архиве и выполните **все** действия оттуда, их там немного, главное сделать все, как написано.
### При попытке ввода информации поле блокируется
Не баг. Решено в [#17](https://github.com/romanespit/Fire-Department-Helper/issues/17).
В поле **Имя и Фамилия** есть фильтр только на русские буквы и пробел. Проблема возникает, если у вас включена на момент ввода английская раскладка.
Решение очевидно: **сменить раскладку на русскую**.
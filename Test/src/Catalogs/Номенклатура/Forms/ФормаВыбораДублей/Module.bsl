
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Наименование") Тогда
		Наименование = Параметры.Наименование;	
	КонецЕсли;
	Если Параметры.Свойство("НаименованиеПолное") Тогда
		НаименованиеПолное = Параметры.НаименованиеПолное;	
	КонецЕсли;
	Если Параметры.Свойство("Артикул") Тогда
		Артикул = Параметры.Артикул;	
	КонецЕсли;
	Если Параметры.Свойство("СсылкаНаРедактируемыйОбъект") Тогда
		СсылкаНаРедактируемыйОбъект = Параметры.СсылкаНаРедактируемыйОбъект;	
	КонецЕсли;
	
	ОбновитьТаблицуДублей();
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПроизведенаЗаменаСсылок" Тогда
		ОбновитьТаблицуДублей();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Номенклатура" Тогда
		ОбновитьТаблицуДублей();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТаблицаДублейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.ТаблицаДублей.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПередачи = Новый Структура("Ключ", Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка);
	ПараметрыПередачи.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта",
		ПараметрыПередачи, 
		Элемент,);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДублейПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элементы.ТаблицаДублей.ТекущиеДанные = Неопределено Тогда
		
		ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиСписка", 0.2, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДокументыПоНоменклатуре(Команда)
	
	Если Элементы.ТаблицаДублей.ТекущиеДанные = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура("Номенклатура", Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка);	
	ПараметрыФормы = Новый Структура(
			"Отбор, КлючНастроек, СформироватьПриОткрытии",
			СтруктураОтбора,
			"Номенклатура",
			Истина);
	
	ОткрытьФорму("Обработка.ДокументыПоКритериюОтбора.Форма.СписокДокументов",
		ПараметрыФормы,
		ЭтотОбъект,
		,
		,
		,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъединитьНоменклатуру(Команда)
	
	МассивНоменклатуры = Новый Массив;
	
	Для Каждого Дубль Из ТаблицаДублей Цикл
		МассивНоменклатуры.Добавить(Дубль.Ссылка);
	КонецЦикла;
	
	ПоискИУдалениеДублейКлиент.ОбъединитьВыделенные(МассивНоменклатуры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	
	ТекущиеДанные = Элементы.ТаблицаДублей.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда Возврат КонецЕсли;
	
	СсылкаНаЭлемент = ТекущиеДанные.Ссылка;
	
	Если ЗначениеЗаполнено(СсылкаНаЭлемент) Тогда
		УстановитьПометкуУдаления(СсылкаНаЭлемент);
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("Ссылка", СсылкаНаЭлемент);
	ОбрабатываемаяСтрока = ТаблицаДублей.НайтиСтроки(ПараметрыОтбора);
	
	Если ОбрабатываемаяСтрока.Количество() Тогда
		ИдентификаторСтроки = ОбрабатываемаяСтрока[0].ПолучитьИдентификатор();
		Элементы.ТаблицаДублей.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПометкуУдаления(СсылкаНаОбъект)
	
	ОбъектПоСсылке = СсылкаНаОбъект.ПолучитьОбъект();
	
	ПометкаУдаления = ?(ОбъектПоСсылке.ПометкаУдаления, Ложь, Истина);
	ОбъектПоСсылке.УстановитьПометкуУдаления(ПометкаУдаления);
	ОбновитьТаблицуДублей();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуДублей()
	
	Если ЗначениеЗаполнено(Наименование) Тогда
		ОбновитьСписокДублейПоНаименованию();
		Элементы.ОбъединитьНоменклатуру.Видимость = ?(ТаблицаДублей.Количество() < 2, Ложь, Истина);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НаименованиеПолное) Тогда
		ОбновитьСписокДублейПоНаименованиюПолному();
		Элементы.ОбъединитьНоменклатуру.Видимость = ?(ТаблицаДублей.Количество() < 2, Ложь, Истина);
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Артикул) Тогда
		ОбновитьСписокДублейПоАртикулу();
		Элементы.ОбъединитьНоменклатуру.Видимость = ?(ТаблицаДублей.Количество() < 2, Ложь, Истина);
		Возврат;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокДублейПоАртикулу()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 20
	|	Номенклатура.Ссылка КАК Ссылка,
	|	Номенклатура.Код КАК Код,
	|	Номенклатура.Наименование КАК Наименование,
	|	Номенклатура.ПометкаУдаления КАК ПометкаУдаления,
	|	Номенклатура.ТипНоменклатуры КАК Тип,
	|	ВЫБОР
	|		КОГДА Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Запас)
	|			ТОГДА 0
	|		КОГДА Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.ПодарочныйСертификат)
	|			ТОГДА 4
	|		ИНАЧЕ 2
	|	КОНЕЦ + ВЫБОР
	|		КОГДА Номенклатура.ИспользоватьХарактеристики
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ + ВЫБОР
	|		КОГДА Номенклатура.ПометкаУдаления
	|			ТОГДА 6
	|		ИНАЧЕ 0
	|	КОНЕЦ + ВЫБОР
	|		КОГДА Номенклатура.ЭтоНабор
	|			ТОГДА 12
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ВариантКартинки,
	|	Номенклатура.Артикул КАК Артикул,
	|	ВЫРАЗИТЬ(Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) КАК НаименованиеПолное,
	|	NULL КАК Характеристика,
	|	NULL КАК АртикулХарактеристики
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Артикул ПОДОБНО &Артикул
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 20
	|	Номенклатура.Ссылка,
	|	Номенклатура.Код,
	|	Номенклатура.Наименование,
	|	Номенклатура.ПометкаУдаления,
	|	Номенклатура.ТипНоменклатуры,
	|	ВЫБОР
	|		КОГДА Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Запас)
	|			ТОГДА 0
	|		КОГДА Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.ПодарочныйСертификат)
	|			ТОГДА 4
	|		ИНАЧЕ 2
	|	КОНЕЦ + ВЫБОР
	|		КОГДА Номенклатура.ИспользоватьХарактеристики
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ + ВЫБОР
	|		КОГДА Номенклатура.ПометкаУдаления
	|			ТОГДА 6
	|		ИНАЧЕ 0
	|	КОНЕЦ + ВЫБОР
	|		КОГДА Номенклатура.ЭтоНабор
	|			ТОГДА 12
	|		ИНАЧЕ 0
	|	КОНЕЦ,
	|	Номенклатура.Артикул,
	|	ВЫРАЗИТЬ(Номенклатура.НаименованиеПолное КАК СТРОКА(1000)),
	|	ХарактеристикиНоменклатуры.Ссылка,
	|	ХарактеристикиНоменклатуры.Артикул
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ПО (ХарактеристикиНоменклатуры.Владелец = Номенклатура.Ссылка)
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Артикул ПОДОБНО &Артикул
	|	И ХарактеристикиНоменклатуры.Владелец <> &Владелец
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	Запрос.УстановитьПараметр("Артикул", Артикул);
	Запрос.УстановитьПараметр("Владелец", СсылкаНаРедактируемыйОбъект);
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаДублей.Загрузить(Запрос.Выполнить().Выгрузить());
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокДублейПоНаименованию()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 20
	|	Номенклатура.Ссылка КАК Ссылка,
	|	Номенклатура.Код КАК Код,
	|	Номенклатура.Наименование КАК Наименование,
	|	Номенклатура.ПометкаУдаления КАК ПометкаУдаления,
	|	Номенклатура.ТипНоменклатуры КАК Тип,
	|	ВЫБОР
	|		КОГДА Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Запас)
	|			ТОГДА 0
	|		КОГДА Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.ПодарочныйСертификат)
	|			ТОГДА 4
	|		ИНАЧЕ 2
	|	КОНЕЦ + ВЫБОР
	|		КОГДА Номенклатура.ИспользоватьХарактеристики
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ + ВЫБОР
	|		КОГДА Номенклатура.ПометкаУдаления
	|			ТОГДА 6
	|		ИНАЧЕ 0
	|	КОНЕЦ + ВЫБОР
	|		КОГДА Номенклатура.ЭтоНабор
	|			ТОГДА 12
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ВариантКартинки,
	|	Номенклатура.Артикул КАК Артикул,
	|	Номенклатура.НаименованиеПолное КАК НаименованиеПолное
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Наименование ПОДОБНО &Наименование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаДублей.Загрузить(Запрос.Выполнить().Выгрузить());
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокДублейПоНаименованиюПолному()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 20
	|	Номенклатура.Ссылка КАК Ссылка,
	|	Номенклатура.Код КАК Код,
	|	Номенклатура.Наименование КАК Наименование,
	|	Номенклатура.ПометкаУдаления КАК ПометкаУдаления,
	|	Номенклатура.ТипНоменклатуры КАК Тип,
	|	ВЫБОР
	|		КОГДА Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Запас)
	|			ТОГДА 0
	|		КОГДА Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.ПодарочныйСертификат)
	|			ТОГДА 4
	|		ИНАЧЕ 2
	|	КОНЕЦ + ВЫБОР
	|		КОГДА Номенклатура.ИспользоватьХарактеристики
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ + ВЫБОР
	|		КОГДА Номенклатура.ПометкаУдаления
	|			ТОГДА 6
	|		ИНАЧЕ 0
	|	КОНЕЦ + ВЫБОР
	|		КОГДА Номенклатура.ЭтоНабор
	|			ТОГДА 12
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ВариантКартинки,
	|	Номенклатура.Артикул КАК Артикул,
	|	Номенклатура.НаименованиеПолное КАК НаименованиеПолное
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.НаименованиеПолное ПОДОБНО &Наименование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	Запрос.УстановитьПараметр("Наименование", НаименованиеПолное);
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаДублей.Загрузить(Запрос.Выполнить().Выгрузить());
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиСписка()
	
	ТекущиеДанные = Элементы.ТаблицаДублей.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда Возврат КонецЕсли;
	
	ЗаголовокКоманды = ?(ТекущиеДанные.ПометкаУдаления
	, НСтр("ru='Снять пометку удаления'"), НСтр("ru='Установить пометку удаления'"));
	
	Элементы.ТаблицаДублейКонтекстноеМенюПометитьНаУдаление.Заголовок = ЗаголовокКоманды;
	
	Элементы.ОткрытьДокументыПоНоменклатуре.Заголовок = СтрШаблон(НСтр("ru='Документы (%1)'"),
		ПолучитьКоличествоДокументовНоменклатура(Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка));
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКоличествоДокументовНоменклатура(Номенклатура)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДокументыПоНоменклатуре.Ссылка) КАК КоличествоДокументов
		|ИЗ
		|	КритерийОтбора.ДокументыПоНоменклатуре(&Номенклатура) КАК ДокументыПоНоменклатуре";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат 0;
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.КоличествоДокументов;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
КонецФункции

&НаКлиенте
Процедура Изменить(Команда)
	
	Если Элементы.ТаблицаДублей.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПередачи = Новый Структура("Ключ", Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка);
	ПараметрыПередачи.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта",
		ПараметрыПередачи,
		Элементы.ТаблицаДублей,);

КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	Заголовок = ЗаголовокФормы();
	
КонецПроцедуры

&НаСервере
Функция ЗаголовокФормы()
	
	Заголовок = НСтр("ru = 'Список дублей по '");

	Если ЗначениеЗаполнено(Артикул) Тогда
		Заголовок = Заголовок + НСтр("ru = 'артикулу'");
		Возврат Заголовок;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Наименование) Тогда
		Заголовок = Заголовок + НСтр("ru = 'наименованию'");
		Возврат Заголовок;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НаименованиеПолное) Тогда
		Заголовок = Заголовок + НСтр("ru = 'наименованию для печати'");
		Возврат Заголовок;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПерейтиКНоменклатуре(Команда)
	
	ТекущийОбъект = Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка;
	ЕстьПравоПоРЛС = ЕстьПравоПоРЛС(ТекущийОбъект);

	Если ЗначениеЗаполнено(СсылкаНаРедактируемыйОбъект) Тогда
		ПараметрыОбъекта = Новый Структура("Ключ", ТекущийОбъект);
		ОткрытьФорму("Справочник.номенклатура.Форма.ФормаЭлемента", ПараметрыОбъекта);
		Возврат;
	КонецЕсли;
	
	Если НЕ ЕстьПравоПоРЛС Тогда
		ТекстПредупреждения = НСтр("ru = 'Нет прав на чтение объекта'");
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ОбработатьВопросПерейтиКОбъекту",ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Продолжить работу с выбранной номенклатурой без сохранения текущей?'");
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);

КонецПроцедуры

&НаСервере
Функция ЕстьПравоПоРЛС(Номенклатура)
	Возврат УправлениеДоступом.ЧтениеРазрешено(Номенклатура);
КонецФункции

&НаКлиенте
Процедура ОбработатьВопросПерейтиКОбъекту(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ВыбранДубльНоменклатуры", Истина);
	ПараметрыЗакрытия.Вставить("ВыбраннаяНоменклатура",     Элементы.ТаблицаДублей.ТекущиеДанные.Ссылка);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

#КонецОбласти

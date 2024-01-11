///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущаяСтрокаИндекс = -1;
	КонфигурацияБазовая = СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации();
	
	СтандартныйПрефикс = ПолучитьНавигационнуюСсылкуИнформационнойБазы() + "/";
	ЭтоВебКлиент = СтрНайти(СтандартныйПрефикс, "http://") > 0;
	Если ЭтоВебКлиент Тогда
		КодЛокализации = ТекущийКодЛокализации();
		СтандартныйПрефикс = СтандартныйПрефикс + КодЛокализации + "/";
	КонецЕсли;
	
	ПравоСохраненияДанных = ПравоДоступа("СохранениеДанныхПользователя", Метаданные);
	
	Если КонфигурацияБазовая Или Не ПравоСохраненияДанных Тогда
		Элементы.ПоказыватьПриНачалеРаботы.Видимость = Ложь;
	Иначе
		ПоказыватьПриНачалеРаботы = ИнформацияПриЗапуске.ПоказыватьПриНачалеРаботы();
	КонецЕсли;
	
	Если Не ПодготовитьДанныеФормы() Тогда
		ОтказВПриОткрытии = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ОтказВПриОткрытии Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВебСодержимоеПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	Если ДанныеСобытия.Свойство("href") И ЗначениеЗаполнено(ДанныеСобытия.href) Тогда
		ИмяОткрываемойСтраницы = СокрЛП(ДанныеСобытия.href);
		Протокол = ВРег(СтрЛевДоСимвола(ИмяОткрываемойСтраницы, ":"));
		Если Протокол <> "HTTP" И Протокол <> "HTTPS" И Протокол <> "E1C" Тогда
			Возврат; // Не ссылка
		КонецЕсли;
		
		ИмяОткрываемойСтраницы = РаскодированнаяСтрока(ИмяОткрываемойСтраницы);
		СтандартныйПрефиксСокращенный = ПолучитьНавигационнуюСсылкуИнформационнойБазы();
		
		Если СтрНайти(ИмяОткрываемойСтраницы, СтандартныйПрефикс) > 0 Тогда
			ИмяОткрываемойСтраницы = СтрЗаменить(ИмяОткрываемойСтраницы, СтандартныйПрефикс, "");
			Если СтрНачинаетсяС(ИмяОткрываемойСтраницы, "#") Тогда
				Возврат;
			КонецЕсли;
			ПросмотрСтраницы("ПоВнутреннейСсылке", ИмяОткрываемойСтраницы);
		ИначеЕсли СтрНайти(ИмяОткрываемойСтраницы, СтрЗаменить(СтандартныйПрефикс, " ", "%20")) > 0 Тогда
			ИмяОткрываемойСтраницы = СтрЗаменить(ИмяОткрываемойСтраницы, "%20", " ");
			ИмяОткрываемойСтраницы = СтрЗаменить(ИмяОткрываемойСтраницы, СтандартныйПрефикс, "");
			Если СтрНачинаетсяС(ИмяОткрываемойСтраницы, "#") Тогда
				Возврат;
			КонецЕсли;
			ПросмотрСтраницы("ПоВнутреннейСсылке", ИмяОткрываемойСтраницы);
		ИначеЕсли СтрНайти(ИмяОткрываемойСтраницы, СтандартныйПрефиксСокращенный) > 0 Тогда
			ИмяОткрываемойСтраницы = СтрЗаменить(ИмяОткрываемойСтраницы, СтандартныйПрефиксСокращенный, "");
			Если СтрНачинаетсяС(ИмяОткрываемойСтраницы, "#") Тогда
				Возврат;
			КонецЕсли;
			ПросмотрСтраницы("ПоВнутреннейСсылке", ИмяОткрываемойСтраницы);
		Иначе
			ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ИмяОткрываемойСтраницы);
		КонецЕсли;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПриНачалеРаботыПриИзменении(Элемент)
	Если Не КонфигурацияБазовая И ПравоСохраненияДанных Тогда
		СохранитьСостояниеФлажка(ПоказыватьПриНачалеРаботы);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Вперед(Команда)
	ПросмотрСтраницы("Вперед", Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	ПросмотрСтраницы("Назад", Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКСтранице(Команда)
	ПросмотрСтраницы("КомандаИзКоманднойПанели", Команда.Имя);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьДанныеФормы()
	НаименованиеТекущегоРаздела = "-";
	ТекущееПодменю = Неопределено;
	ДобавленоПодменю = 0;
	ПакетыСМинимальнымПриоритетом = Новый Массив;
	ГлавнаяЗанята = Ложь;
	
	ИспользоватьКэшРегистра = Истина;
	Если ОбщегоНазначения.РежимОтладки()
		Или НРег(СтрЛевДоСимвола(ИмяФормы, ".")) = НРег("ВнешняяОбработка") Тогда
		ИспользоватьКэшРегистра = Ложь;
	КонецЕсли;
	
	Если ИспользоватьКэшРегистра Тогда
		УстановитьПривилегированныйРежим(Истина);
		ЗаписьРегистра = РегистрыСведений.ПакетыИнформацииПриЗапуске.Получить(Новый Структура("Номер", 0));
		ПакетыСтраниц = ЗаписьРегистра.Состав.Получить();
		УстановитьПривилегированныйРежим(Ложь);
		Если ПакетыСтраниц = Неопределено Тогда
			ИспользоватьКэшРегистра = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ИспользоватьКэшРегистра Тогда
		ПакетыСтраниц = ИнформацияПриЗапуске.ПакетыСтраниц(РеквизитФормыВЗначение("Объект"));
	КонецЕсли;
	
	Информация = ИнформацияПриЗапуске.ПодготовитьПакетыСтраницКВыводу(ПакетыСтраниц, НачалоДня(ТекущаяДатаСеанса()));
	Если Информация.ПодготовленныеПакеты.Количество() = 0
		Или Информация.МинимальныйПриоритет = 100 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПодготовленныеПакеты.Загрузить(Информация.ПодготовленныеПакеты);
	ПодготовленныеПакеты.Сортировать("Раздел");
	Для Каждого ПакетСтраниц Из ПодготовленныеПакеты Цикл
		ПакетСтраниц.ЗаголовокФормы = НСтр("ru = 'Информация'");
		
		Если ПакетСтраниц.Приоритет = Информация.МинимальныйПриоритет Тогда
			ПакетыСМинимальнымПриоритетом.Добавить(ПакетСтраниц);
		КонецЕсли;
		
		Если СтрНачинаетсяС(ПакетСтраниц.Раздел, "_") Тогда
			НомерПодменю = Сред(ПакетСтраниц.Раздел, 2);
			Если НомерПодменю = "0" Тогда
				ПакетСтраниц.Раздел = "";
				Если Не ГлавнаяЗанята Тогда
					ПакетСтраниц.Идентификатор = "ГлавнаяСтраница";
					ГлавнаяЗанята = Истина;
					Продолжить;
				КонецЕсли;
				ТекущееПодменю = Элементы.БезПодменю;
			Иначе
				ИмяПодменю = "Подменю" + НомерПодменю;
				ТекущееПодменю = Элементы.Найти(ИмяПодменю);
				Если ТекущееПодменю = Неопределено Тогда
					ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не найдена группа ""%1""'"), ИмяПодменю);
				КонецЕсли;
				ПакетСтраниц.Раздел = ТекущееПодменю.Заголовок;
			КонецЕсли;
		ИначеЕсли НаименованиеТекущегоРаздела <> ПакетСтраниц.Раздел Тогда
			НаименованиеТекущегоРаздела = ПакетСтраниц.Раздел;
			
			ЭтоГлавная = (ПакетСтраниц.Раздел = НСтр("ru = 'Главная'"));
			Если ЭтоГлавная И Не ГлавнаяЗанята Тогда
				ПакетСтраниц.Идентификатор = "ГлавнаяСтраница";
				ГлавнаяЗанята = Истина;
				Продолжить;
			КонецЕсли;
			
			Если ЭтоГлавная Или ПакетСтраниц.Раздел = "" Тогда
				ТекущееПодменю = Элементы.БезПодменю;
			Иначе
				ДобавленоПодменю = ДобавленоПодменю + 1;
				ИмяПодменю = "Подменю" + Строка(ДобавленоПодменю);
				ТекущееПодменю = Элементы.Найти(ИмяПодменю);
				Если ТекущееПодменю = Неопределено Тогда
					ТекущееПодменю = Элементы.Добавить(ИмяПодменю, Тип("ГруппаФормы"), Элементы.ВерхняяПанель);
					ТекущееПодменю.Вид = ВидГруппыФормы.Подменю;
				КонецЕсли;
				ТекущееПодменю.Заголовок = ПакетСтраниц.Раздел;
			КонецЕсли;
		КонецЕсли;
		
		Если ТекущееПодменю <> Элементы.БезПодменю Тогда
			ПакетСтраниц.ЗаголовокФормы = ПакетСтраниц.ЗаголовокФормы + ": " + ПакетСтраниц.Раздел +" / "+ ПакетСтраниц.НаименованиеСтартовойСтраницы;
		КонецЕсли;
		
		ИмяКоманды = "ДобавленныйЭлемент_" + ПакетСтраниц.Идентификатор;
		
		Команда = Команды.Добавить(ИмяКоманды);
		Команда.Действие = "Подключаемый_ПерейтиКСтранице";
		Команда.Заголовок = ПакетСтраниц.НаименованиеСтартовойСтраницы;
		
		Кнопка = Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), ТекущееПодменю);
		Кнопка.ИмяКоманды = ИмяКоманды;
		
	КонецЦикла;
	
	Элементы.ГлавнаяСтраница.Видимость = ГлавнаяЗанята;
	
	// Определение пакета для отображения.
	ГСЧ = Новый ГенераторСлучайныхЧисел;
	НомерСтроки = ГСЧ.СлучайноеЧисло(1, ПакетыСМинимальнымПриоритетом.Количество());
	СтартовыйПакетСтраниц = ПакетыСМинимальнымПриоритетом[НомерСтроки-1];
	
	// Чтение пакета из регистра.
	Если ИспользоватьКэшРегистра Тогда
		Фильтр = Новый Структура("Номер", СтартовыйПакетСтраниц.НомерВРегистре);
		УстановитьПривилегированныйРежим(Истина);
		ЗаписьРегистра = РегистрыСведений.ПакетыИнформацииПриЗапуске.Получить(Фильтр);
		ФайлыПакета = ЗаписьРегистра.Состав.Получить();
		УстановитьПривилегированныйРежим(Ложь);
	Иначе
		ФайлыПакета = Неопределено;
	КонецЕсли;
	Если ФайлыПакета = Неопределено Тогда
		ФайлыПакета = ИнформацияПриЗапуске.ИзвлечьФайлыПакета(РеквизитФормыВЗначение("Объект"), СтартовыйПакетСтраниц.ИмяМакета);
	КонецЕсли;
	
	Если ФайлыПакета = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Подготовка пакета к показу.
	РазместитьСтраницыПакета(СтартовыйПакетСтраниц, ФайлыПакета);
	
	// Показ первой страницы.
	Если Не ПросмотрСтраницы("КомандаИзТаблицыДобавленных", СтартовыйПакетСтраниц) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

&НаСервере
Функция ПросмотрСтраницы(ТипДействия, Параметр = Неопределено)
	Перем ПакетСтраниц, АдресСтраницы, НоваяСтрокаИстории, НоваяСтрокаИндекс;
	
	Если ТипДействия = "ПоВнутреннейСсылке" Тогда
		
		ИмяОткрываемойСтраницы = Параметр;
		СтрокаИстории = ИсторияПросмотра.Получить(ТекущаяСтрокаИндекс);
		ПакетСтраниц = ПодготовленныеПакеты.НайтиПоИдентификатору(СтрокаИстории.ИдентификаторПакета);
		
		Поиск = Новый Структура("ОтносительноеИмя", СтрЗаменить(ИмяОткрываемойСтраницы, "\", "/"));
		
		Найденные = ПакетСтраниц.ВебСтраницы.НайтиСтроки(Поиск);
		Если Найденные.Количество() = 0 Тогда
			Возврат Ложь;
		КонецЕсли;
		АдресСтраницы = Найденные[0].Адрес;
		
	ИначеЕсли ТипДействия = "Назад" Или ТипДействия = "Вперед" Тогда
		
		СтрокаИстории = ИсторияПросмотра.Получить(ТекущаяСтрокаИндекс);
		
		НоваяСтрокаИндекс = ТекущаяСтрокаИндекс + ?(ТипДействия = "Назад", -1, +1);
		НоваяСтрокаИстории = ИсторияПросмотра[НоваяСтрокаИндекс];
		
		ПакетСтраниц = ПодготовленныеПакеты.НайтиПоИдентификатору(НоваяСтрокаИстории.ИдентификаторПакета);
		АдресСтраницы = НоваяСтрокаИстории.АдресСтраницы;
		
	ИначеЕсли ТипДействия = "КомандаИзКоманднойПанели" Тогда
		
		ИмяКоманды = Параметр;
		Найденные = ПодготовленныеПакеты.НайтиСтроки(Новый Структура("Идентификатор", СтрЗаменить(ИмяКоманды, "ДобавленныйЭлемент_", "")));
		Если Найденные.Количество() = 0 Тогда
			Возврат Ложь;
		КонецЕсли;
		ПакетСтраниц = Найденные[0];
		
	ИначеЕсли ТипДействия = "КомандаИзТаблицыДобавленных" Тогда
		
		ПакетСтраниц = Параметр;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
	// Размещение во временном хранилище.
	Если ПакетСтраниц.АдресСтартовойСтраницы = "" Тогда
		ФайлыПакета = ИнформацияПриЗапуске.ИзвлечьФайлыПакета(РеквизитФормыВЗначение("Объект"), ПакетСтраниц.ИмяМакета);
		РазместитьСтраницыПакета(ПакетСтраниц, ФайлыПакета);
	КонецЕсли;
	
	// Получение адреса размещения страницы во временном хранилище.
	Если АдресСтраницы = Неопределено Тогда
		АдресСтраницы = ПакетСтраниц.АдресСтартовойСтраницы;
	КонецЕсли;
	
	// Регистрация в истории просмотра.
	Если НоваяСтрокаИстории = Неопределено Тогда
		
		НоваяСтрокаИсторииСтруктура = Новый Структура("ИдентификаторПакета, АдресСтраницы");
		НоваяСтрокаИсторииСтруктура.ИдентификаторПакета = ПакетСтраниц.ПолучитьИдентификатор();
		НоваяСтрокаИсторииСтруктура.АдресСтраницы = АдресСтраницы;
		
		Найденные = ИсторияПросмотра.НайтиСтроки(НоваяСтрокаИсторииСтруктура);
		Для Каждого НоваяСтрокаИсторииДубль Из Найденные Цикл
			ИсторияПросмотра.Удалить(НоваяСтрокаИсторииДубль);
		КонецЦикла;
		
		НоваяСтрокаИстории = ИсторияПросмотра.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаИстории, НоваяСтрокаИсторииСтруктура);
		
	КонецЕсли;
	
	Если НоваяСтрокаИндекс = Неопределено Тогда
		НоваяСтрокаИндекс = ИсторияПросмотра.Индекс(НоваяСтрокаИстории);
	КонецЕсли;
	
	Если ТипДействия = "ПоВнутреннейСсылке" И ТекущаяСтрокаИндекс <> -1 И ТекущаяСтрокаИндекс <> НоваяСтрокаИндекс - 1 Тогда
		РазницаИндексов = ТекущаяСтрокаИндекс - НоваяСтрокаИндекс;
		Сдвиг = РазницаИндексов + ?(РазницаИндексов < 0, 1, 0);
		ИсторияПросмотра.Сдвинуть(НоваяСтрокаИндекс, Сдвиг);
		НоваяСтрокаИндекс = НоваяСтрокаИндекс + Сдвиг;
	КонецЕсли;
	
	ТекущаяСтрокаИндекс = НоваяСтрокаИндекс;
	
	// Видимость и доступность.
	Элементы.ФормаНазад.Доступность = (ТекущаяСтрокаИндекс > 0);
	Элементы.ФормаВперед.Доступность = (ТекущаяСтрокаИндекс < ИсторияПросмотра.Количество() - 1);
	
	// Установка веб содержимого и заголовка формы.
	ВебСодержимое = ПолучитьИзВременногоХранилища(АдресСтраницы);
	Заголовок = ПакетСтраниц.ЗаголовокФормы;
	
	Возврат Истина;
КонецФункции

&НаСервере
Процедура РазместитьСтраницыПакета(ПакетСтраниц, ФайлыПакета)
	
	Колонки = ФайлыПакета.Картинки.Колонки; // КоллекцияКолонокТаблицыЗначений
	Колонки.Добавить("Адрес", Новый ОписаниеТипов("Строка"));
	
	// Регистрация картинок и ссылок на страницы встроенной справки.
	Для Каждого ВебСтраница Из ФайлыПакета.ВебСтраницы Цикл
		ТекстHTML = ВебСтраница.Данные;
		
		// Регистрация картинок.
		Длина = СтрДлина(ВебСтраница.ОтносительныйКаталог);
		Для Каждого Картинка Из ФайлыПакета.Картинки Цикл
			// Помещение картинок во временное хранилище.
			Если ПустаяСтрока(Картинка.Адрес) Тогда
				Картинка.Адрес = ПоместитьВоВременноеХранилище(Картинка.Данные, УникальныйИдентификатор);
			КонецЕсли;
			// Вычисление пути к картинки от страницы.
			// Например в странице "/1/a.htm" путь к картинке "/1/2/b.png" будет значиться как "2/b.png".
			ПутьККартинке = Картинка.ОтносительноеИмя;
			Если Длина > 0 И СтрНачинаетсяС(ПутьККартинке, ВебСтраница.ОтносительныйКаталог) Тогда
				ПутьККартинке = Сред(ПутьККартинке, Длина + 1);
			КонецЕсли;
			// Замена относительных путей картинки на адреса во временном хранилище.
			ТекстHTML = СтрЗаменить(ТекстHTML, ПутьККартинке, Картинка.Адрес);
		КонецЦикла;
		
		// Замена относительных встроенных ссылок на абсолютные для этой ИБ.
		ТекстHTML = СтрЗаменить(ТекстHTML, "v8config://", СтандартныйПрефикс + "e1cib/helpservice/topics/v8config/");
		
		// Регистрация гиперссылок встроенной справки.
		ДобавитьГиперссылкиВстроеннойСправки(ТекстHTML, ПакетСтраниц.ВебСтраницы);
		
		// Размещение HTML содержимого во временном хранилище.
		РегистрацияВебСтраницы = ПакетСтраниц.ВебСтраницы.Добавить();
		РегистрацияВебСтраницы.ОтносительноеИмя     = ВебСтраница.ОтносительноеИмя;
		РегистрацияВебСтраницы.ОтносительныйКаталог = ВебСтраница.ОтносительныйКаталог;
		РегистрацияВебСтраницы.Адрес                = ПоместитьВоВременноеХранилище(ТекстHTML, УникальныйИдентификатор);
		
		// Регистрация стартовой страницы.
		Если РегистрацияВебСтраницы.ОтносительноеИмя = ПакетСтраниц.ИмяФайлаСтартовойСтраницы Тогда
			ПакетСтраниц.АдресСтартовойСтраницы = РегистрацияВебСтраницы.Адрес;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьСостояниеФлажка(ПоказыватьПриНачалеРаботы)
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ИнформацияПриЗапуске", "Показывать", ПоказыватьПриНачалеРаботы);
	Если Не ПоказыватьПриНачалеРаботы Тогда
		ДатаБлижайшегоПоказа = НачалоДня(ТекущаяДатаСеанса() + 14*24*60*60);
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ИнформацияПриЗапуске", "ДатаБлижайшегоПоказа", ДатаБлижайшегоПоказа);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьГиперссылкиВстроеннойСправки(ТекстHTML, ВебСтраницы)
	ПрефиксГиперссылкиВстроеннойСправки = """" + СтандартныйПрефикс + "e1cib/helpservice/topics/v8config/v8cfgHelp/";
	Остаток = ТекстHTML;
	Пока Истина Цикл
		ПозицияПрефикса = СтрНайти(Остаток, ПрефиксГиперссылкиВстроеннойСправки);
		Если ПозицияПрефикса = 0 Тогда
			Прервать;
		КонецЕсли;
		Остаток = Сред(Остаток, ПозицияПрефикса + 1);
		
		ПозицияКавычки = СтрНайти(Остаток, """");
		Если ПозицияКавычки = 0 Тогда
			Прервать;
		КонецЕсли;
		Гиперссылка = Лев(Остаток, ПозицияКавычки - 1);
		Остаток = Сред(Остаток, ПозицияКавычки + 1);
		
		ОтносительноеИмя = СтрЗаменить(Гиперссылка, СтандартныйПрефикс, "");
		Содержимое = Гиперссылка;
		
		РазмещениеФайла = ВебСтраницы.Добавить();
		РазмещениеФайла.ОтносительноеИмя = ОтносительноеИмя;
		РазмещениеФайла.Адрес = ПоместитьВоВременноеХранилище(Содержимое, УникальныйИдентификатор);
		РазмещениеФайла.ОтносительныйКаталог = "";
	КонецЦикла;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтрЛевДоСимвола(Строка, Разделитель, Остаток = Неопределено)
	Позиция = СтрНайти(Строка, Разделитель);
	Если Позиция = 0 Тогда
		СтрокаДоТочки = Строка;
		Остаток = "";
	Иначе
		СтрокаДоТочки = Лев(Строка, Позиция - 1);
		Остаток = Сред(Строка, Позиция + СтрДлина(Разделитель));
	КонецЕсли;
	Возврат СтрокаДоТочки;
КонецФункции

&НаСервере
Функция РаскодированнаяСтрока(Строка)
	
	Возврат РаскодироватьСтроку(Строка, СпособКодированияСтроки.КодировкаURL);
	
КонецФункции

#КонецОбласти

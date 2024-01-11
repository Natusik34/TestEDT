///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Создание структуры с реквизитами обработки.
	Элементы.НадписьЛогина.Заголовок = НСтр("ru = 'Логин:'") + " " + Параметры.login;
	
	СтатусФормы      = Параметры.statusApplicationFormED;
	НомерЗаявки      = Параметры.numberRequestED;
	СтрокаДатаЗаявки = Параметры.dateRequestED;
	СтатусЗаявки     = Параметры.applicationStatusED;
	
	Если НЕ ПустаяСтрока(СтрокаДатаЗаявки) Тогда
		Попытка
			ДатаЗаявки = Дата(СтрЗаменить(СтрЗаменить(СтрЗаменить(СтрокаДатаЗаявки, "-", "")," ",""), ":",""));
		Исключение
			ДатаЗаявки = Дата(1,1,1);
		КонецПопытки;
	Иначе
		ДатаЗаявки = Дата(1,1,1);
	КонецЕсли;
	
	Если СтатусФормы = "new" ИЛИ НЕ ЗначениеЗаполнено(СтатусФормы) Тогда
		
		Элементы.НадписьЗаголовкаФормы.Заголовок = НСтр("ru = 'Заявка на регистрацию участника обмена ЭД'");
		Элементы.НадписьСтатусаЗаявки.Заголовок = НСтр("ru = 'Новая заявка'");
		Элементы.ОтправитьЗаявку.Видимость = Истина;
		
		Элементы.СтраницыЗаявкиНаРегистрацию.ТекущаяСтраница = Элементы.СтраницаЗаявкиНаРегистрацию;
		
	ИначеЕсли СтатусФормы = "change" Тогда
		
		Элементы.НадписьЗаголовкаФормы.Заголовок = НСтр("ru = 'Изменение данных участника обмена ЭД'");
		Элементы.НадписьСтатусаЗаявки.Заголовок = НСтр("ru = 'Новая заявка'");
		Элементы.ОтправитьЗаявку.Видимость = Истина;
		
		Элементы.СтраницыЗаявкиНаРегистрацию.ТекущаяСтраница = Элементы.СтраницаЗаявкиНаИзменение;
		
	ИначеЕсли СтатусФормы = "show" Тогда
		
		ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Заявка №%1 от %2'"),
			НомерЗаявки,
			Формат(ДатаЗаявки, "ДЛФ=DDT"));
		
		Элементы.НадписьЗаголовкаФормы.Заголовок = ТекстЗаголовка;
		
		Элементы.ОтправитьЗаявку.Видимость = Ложь;
		Элементы.Закрыть.КнопкаПоУмолчанию = Истина;
		
		СертификатЭП = Параметры.nameCertificateED;
		
		Если НЕ ЗначениеЗаполнено(СертификатЭП) Тогда
			Элементы.СертификатЭП.Видимость = Ложь;
		КонецЕсли;
		
		Элементы.СертификатЭП.КнопкаВыбора = Ложь;
		Элементы.СтраницыЗаявкиНаРегистрацию.ТекущаяСтраница = Элементы.СтраницаЗаявкиНаИзменение;
		ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтатусЗаявки) ИЛИ СтатусЗаявки = "none" Тогда
		
		ТекстСтатуса = НСтр("ru='Новая заявка.'");
		Элементы.НадписьПричина.Видимость = Ложь;
		
	ИначеЕсли СтатусЗаявки = "notconsidered" Тогда
		
		ТекстСтатуса = НСтр("ru='Заявка оператором еще не рассмотрена.'");
		Элементы.НадписьПричина.Видимость = Ложь;
		
	ИначеЕсли СтатусЗаявки = "rejected" Тогда
		
		ТекстСтатуса = НСтр("ru='Заявка оператором отклонена.'");
		Элементы.НадписьПричина.Видимость = Истина;
		
	Иначе
		
		// Статус заявки - "obtained".
		ТекстСтатуса = НСтр("ru='Заявка успешно выполнена оператором'");
		Элементы.НадписьПричина.Видимость = Ложь;
		
	КонецЕсли;
	
	Элементы.НадписьСтатусаЗаявки.Заголовок = ТекстСтатуса;
	
	// Обновление сведений об организации
	ОбновитьСведенияОбОрганизации();
	
	Если ТолькоПросмотр Тогда
		Элементы.Адрес.КнопкаВыбора   = Ложь;
		Элементы.Адрес.КнопкаОткрытия = Истина;
	Иначе
		Элементы.Адрес.КнопкаВыбора   = Истина;
		Элементы.Адрес.КнопкаОткрытия = Ложь;
	КонецЕсли;
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ГруппаПояснение.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.ГруппаСведенийОбОрганизации.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Элементы.ГруппаКонтактнойИнформации.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Элементы.ГруппаСведенийОРуководителеОрганизации.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
	КонецЕсли;
	
	Элементы.ДекорацияТехПоддержка.Видимость
		= ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Подключение1СТакскомКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ПрограммноеЗакрытие Тогда
		
		Если Модифицированность Тогда
			
			Отказ = Истина;
			Если ЗавершениеРаботы Тогда
				ТекстПредупреждения =
					НСтр("ru = 'Заявка на регистрацию данных участника обмена электронными документами не отправлена.'");
			Иначе
				ОписаниеОповещения = Новый ОписаниеОповещения(
					"ПриОтветеНаВопросОЗакрытииМодифицированнойФормы",
					ЭтотОбъект);
				
				ТекстВопроса = НСтр("ru = 'Данные заявки изменены. Закрыть форму без сохранения данных?'");
				ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			КонецЕсли;
			Возврат;
			
		КонецЕсли;
		
		Если Не ЗавершениеРаботы И СтатусФормы <> "show" И Не НажатаКнопкаОтправить Тогда
			// Обработать закрытие формы в бизнес-процессе.
			
			ПараметрыЗапроса = Новый Массив;
			ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "endForm", "close"));
			Подключение1СТакскомКлиент.ОбработкаКомандСервиса(
				КонтекстВзаимодействия,
				ЭтотОбъект,
				ПараметрыЗапроса);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Подготовка данных и открытие формы для ввода адреса
	СтандартнаяОбработка = Ложь;
	ВыбратьАдрес(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьАдрес(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПричинаНажатие(Элемент)
	
	Подключение1СТакскомКлиент.ПоказатьПричинуОтклоненияЗаявкиЭДО(КонтекстВзаимодействия);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВыходНажатие(Элемент)
	
	Подключение1СТакскомКлиент.ОбработатьВыходПользователя(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЮрФизЛицоПриИзменении(Элемент)
	
	НастройкиПоЮрФизЛицу();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияТехПоддержкаОбработкаНавигационнойСсылки(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "TechSupport" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекстСообщения = НСтр("ru = '%1.
			|
			|%2'");
		
		Если СтатусФормы = "new" ИЛИ ПустаяСтрока(СтатусФормы) Тогда
			ЧтоНеПолучилось = НСтр("ru = 'Не получается отправить заявку на регистрацию участника обмена ЭД'");
		ИначеЕсли СтатусФормы = "change" Тогда
			ЧтоНеПолучилось = НСтр("ru = 'Не получается отправить заявку на изменение данных участника обмена ЭД'");
		ИначеЕсли СтатусФормы = "show" Тогда
			ЧтоНеПолучилось = НСтр("ru = 'Возникли проблемы с заявкой участника обмена ЭД'");
		КонецЕсли;
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения,
			ЧтоНеПолучилось,
			Подключение1СТакскомКлиент.ТекстТехническихПараметровЭДО(КонтекстВзаимодействия, СертификатЭП));
		
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки") Тогда
			
			МодульСообщенияВСлужбуТехническойПоддержкиКлиентСервер =
				ОбщегоНазначенияКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиКлиентСервер");
			ДанныеСообщения = МодульСообщенияВСлужбуТехническойПоддержкиКлиентСервер.ДанныеСообщения();
			ДанныеСообщения.Получатель = "taxcom";
			ДанныеСообщения.Тема = НСтр("ru = 'Интернет-поддержка. Заявка на регистрацию участника обмена ЭД в 1С-Такском'");
			ДанныеСообщения.Сообщение  = ТекстСообщения;
		
			МодульСообщенияВСлужбуТехническойПоддержкиКлиент =
				ОбщегоНазначенияКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиКлиент");
			МодульСообщенияВСлужбуТехническойПоддержкиКлиент.ОтправитьСообщение(
				ДанныеСообщения);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьЗаявку(Команда)
	
	// Проверка заполнения необходимых полей
	Ошибка = Ложь;
	
	Если ПустаяСтрока(Организация) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""Организация""'");
		Сообщение.Поле = "Организация";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(Адрес) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""Адрес""'");
		Сообщение.Поле = "Адрес";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(Телефон) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""Телефон""'");
		Сообщение.Поле = "Телефон";
		Сообщение.Сообщить();
	КонецЕсли;
	
	// Проверка адреса
	
	Если ПустаяСтрока(КодРегиона) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст =
			НСтр("ru ='Не указан ""Код региона"" (Код региона нужно указать в форме ""Адрес участника обмена ЭД"")'");
		Сообщение.Поле = "Адрес";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(ИНН) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""ИНН""'");
		Сообщение.Поле = "ИНН";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ЮрФизЛицо <> "ЮрЛицо" И ЮрФизЛицо <> "ФизЛицо" Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не выбран тип организации (юридическое или физическое лицо)'");
		Сообщение.Поле = "ЮрФизЛицо";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(КПП) И ЮрФизЛицо = "ЮрЛицо" Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""КПП""'");
		Сообщение.Поле = "КПП";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(ОГРН) И ЮрФизЛицо = "ЮрЛицо" Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""ОГРН""'");
		Сообщение.Поле = "ОГРН";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(КодНалоговогоОргана) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""Код налогового органа""'");
		Сообщение.Поле = "КодНалоговогоОргана";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(Фамилия) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""Фамилия""'");
		Сообщение.Поле = "Фамилия";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если ПустаяСтрока(Имя) Тогда
		Ошибка    = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru ='Не заполнено поле ""Имя""'");
		Сообщение.Поле = "Имя";
		Сообщение.Сообщить();
	КонецЕсли;
	
	// Дополнительные проверки
	
	Если НЕ ПустаяСтрока(Телефон) Тогда
		Если СтрДлина(Телефон) > 20 Тогда
			Ошибка    = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru ='""Телефон"" должен содержать не более 20 символов'");
			Сообщение.Поле = "Телефон";
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЕсли;
	
	ОписаниеТипаЧисло = Новый ОписаниеТипов("Число");
	
	Если НЕ ПустаяСтрока(КодРегиона) Тогда
		Если КодРегиона <> "0" Тогда
			КодРегионаЧисло = ОписаниеТипаЧисло.ПривестиЗначение(СокрЛП(КодРегиона));
			Если КодРегионаЧисло = 0 Тогда
				Ошибка    = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru ='В ""Коде региона"" использованы недопустимые символы'");
				Сообщение.Поле = "Адрес";
				Сообщение.Сообщить();
			Иначе
				Если СтрДлина(СокрЛП(КодРегиона)) <> 2 Тогда
					Ошибка    = Истина;
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = НСтр("ru ='""Код региона"" должен содержать 2 цифры'");
					Сообщение.Поле = "Адрес";
					Сообщение.Сообщить();
				Иначе
					Если КодРегионаЧисло > 99 ИЛИ КодРегионаЧисло < 1 Тогда
						Ошибка    = Истина;
						Сообщение = Новый СообщениеПользователю;
						Сообщение.Текст = НСтр("ru ='""Код региона"" должен быть от 01 до 99'");
						Сообщение.Поле = "КодРегиона";
						Сообщение.Сообщить();
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		Иначе
			Ошибка    = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru ='""Код региона"" должен содержать 2 цифры'");
			Сообщение.Поле = "Адрес";
			Сообщение.Сообщить();
			КодРегионаЧисло = 0;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ИНН) Тогда
		Если ИНН <> "0" Тогда
			ИННЧисло = ОписаниеТипаЧисло.ПривестиЗначение(СокрЛП(ИНН));
			Если ИННЧисло = 0 Тогда
				Ошибка    = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru ='""ИНН"" должен содержать 12 цифр'");
				Сообщение.Поле = "ИНН";
				Сообщение.Сообщить();
			Иначе
				Если СтрДлина(СокрЛП(ИНН)) <> 12 И ЮрФизЛицо = "ФизЛицо" Тогда
					Ошибка    = Истина;
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = НСтр("ru ='""ИНН"" должен содержать 12 цифр'");
					Сообщение.Поле = "ИНН";
					Сообщение.Сообщить();
				ИначеЕсли СтрДлина(СокрЛП(ИНН)) <> 10 И ЮрФизЛицо = "ЮрЛицо" Тогда
					Ошибка    = Истина;
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = НСтр("ru ='""ИНН"" должен содержать 10 цифр'");
					Сообщение.Поле = "ИНН";
					Сообщение.Сообщить();
				КонецЕсли;
			КонецЕсли;
		Иначе
			Ошибка    = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru ='""ИНН"" должен содержать 12 цифр'");
			Сообщение.Поле = "ИНН";
			Сообщение.Сообщить();
			ИННЧисло = 0;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(КПП) Тогда
		Если КПП <> "0" Тогда
			КППЧисло = ОписаниеТипаЧисло.ПривестиЗначение(СокрЛП(КПП));
			Если КППЧисло = 0 Тогда
				Ошибка    = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru ='В ""КПП"" использованы недопустимые символы'");
				Сообщение.Поле = "КПП";
				Сообщение.Сообщить();
			Иначе
				Если СтрДлина(СокрЛП(КПП)) <> 9 Тогда
					Ошибка    = Истина;
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = НСтр("ru ='""КПП"" должен содержать 9 цифр'");
					Сообщение.Поле = "КПП";
					Сообщение.Сообщить();
				КонецЕсли;
			КонецЕсли;
		Иначе
			Ошибка    = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru ='""КПП"" должен содержать 9 цифр'");
			Сообщение.Поле = "КПП";
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ОГРН) Тогда
		Если ОГРН <> "0" Тогда
			ОГРНЧисло = ОписаниеТипаЧисло.ПривестиЗначение(СокрЛП(ОГРН));
			Если ОГРНЧисло = 0 Тогда
				Ошибка    = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru ='В ""ОГРН"" использованы недопустимые символы'");
				Сообщение.Поле = "ОГРН";
				Сообщение.Сообщить();
			Иначе
				Если СтрДлина(СокрЛП(ОГРН)) <> 13  И ЮрФизЛицо = "ЮрЛицо" Тогда
					Ошибка    = Истина;
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = НСтр("ru ='""ОГРН"" должен содержать 13 цифр'");
					Сообщение.Поле = "ОГРН";
					Сообщение.Сообщить();
				ИначеЕсли СтрДлина(СокрЛП(ОГРН)) <> 15  И ЮрФизЛицо = "ФизЛицо" Тогда
					Ошибка    = Истина;
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = НСтр("ru ='""ОГРН"" должен содержать 15 цифр'");
					Сообщение.Поле = "ОГРН";
					Сообщение.Сообщить();
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если СтрДлина(СокрЛП(ОГРН)) <> 13  И ЮрФизЛицо = "ЮрЛицо" Тогда
					Ошибка    = Истина;
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = НСтр("ru ='""ОГРН"" должен содержать 13 цифр'");
					Сообщение.Поле = "ОГРН";
					Сообщение.Сообщить();
			ИначеЕсли СтрДлина(СокрЛП(ОГРН)) <> 15  И ЮрФизЛицо = "ФизЛицо" Тогда
				Ошибка    = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru ='""ОГРН"" должен содержать 15 цифр'");
				Сообщение.Поле = "ОГРН";
				Сообщение.Сообщить();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(КодНалоговогоОргана) Тогда
		Если КодНалоговогоОргана <> "0" Тогда
			Если ОГРНЧисло = 0 Тогда
				Ошибка    = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru ='В ""Коде налогового органа"" использованы недопустимые символы'");
				Сообщение.Поле = "КодНалоговогоОргана";
				Сообщение.Сообщить();
			Иначе
				Если СтрДлина(СокрЛП(КодНалоговогоОргана)) <> 4 Тогда
					Ошибка    = Истина;
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = НСтр("ru ='""Код налогового органа"" должен содержать 4 цифры'");
					Сообщение.Поле = "КодНалоговогоОргана";
					Сообщение.Сообщить();
				КонецЕсли;
			КонецЕсли;
		Иначе
			Ошибка    = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru ='""Код налогового органа"" должен содержать 4 цифры'");
			Сообщение.Поле = "КодНалоговогоОргана";
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЕсли;
	
	Если Ошибка Тогда
		Возврат;
	КонецЕсли;
	
	// Передача данных на сервер
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "endForm"           , "send"));
	// Это признак нажатия кнопки "Отправить"
	
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "postindexED"       , Индекс));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addressregionED"   , Регион));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "codregionED"       , КодРегиона));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addresstownshipED" , Район));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addresscityED"     , Город));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addresslocalityED" , НаселенныйПункт));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addressstreetED"   , Улица));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addressbuildingED" , Дом));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addresshousingED"  , Корпус));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addressapartmentED", Квартира));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addressphoneED"    , Телефон));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "agencyED"          , Организация));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "innED"             , ИНН));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "kppED"             , КПП));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "ogrnED"            , ОГРН));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "codeimnsED"        , КодНалоговогоОргана));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "lastnameED"        , Фамилия));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "firstnameED"       , Имя));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "middlenameED"      , Отчество));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "identifierTaxcomED", ИдентификаторОрганизации));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "orgindED"          , ЮрФизЛицо));
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "addressED"         , Адрес));
	
	Если СтатусФормы <> "show" Тогда
		
		Если ЗначениеЗаполнено(СертификатЭП) Тогда
			
			ПрежнийСертификат = Подключение1СТакскомКлиент.ЗначениеСессионногоПараметра(
				КонтекстВзаимодействия.КСКонтекст,
				"IDCertificateED");
			
			ПредставлениеСертификата = "";
			ДвоичныеДанныеСертификата = Подключение1СТакскомВызовСервера.ДвоичныеДанныеСертификата(СертификатЭП, ПредставлениеСертификата);
			
			Если СертификатЭП <> ПрежнийСертификат Тогда
				
				Подключение1СТакскомКлиентСервер.ЗаписатьПараметрКонтекста(
					КонтекстВзаимодействия.КСКонтекст,
					"IDCertificateED_Dop",
					СертификатЭП);
				
			КонецЕсли;
			
			ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "nameCertificateED", ПредставлениеСертификата));
			
			Если ДвоичныеДанныеСертификата <> Неопределено Тогда
				
				СтрокаBase64 = Base64Строка(ДвоичныеДанныеСертификата);
				ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "certificateED", СтрокаBase64));
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЭтотОбъект.Модифицированность = Ложь;
	НажатаКнопкаОтправить = Истина;
	
	// Отправить параметры на сервер
	
	Подключение1СТакскомКлиент.ОбработкаКомандСервиса(
		КонтекстВзаимодействия,
		ЭтотОбъект,
		ПараметрыЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура, которая получает сведения об организации
// из конфигурации по данным организации.
&НаСервере
Процедура ОбновитьСведенияОбОрганизации()
	
	ЮрФизЛицо                = Параметры.orgindED;
	Индекс                   = Параметры.postindexED;
	Регион                   = Параметры.addressregionED;
	КодРегиона               = Параметры.coderegionED;
	Район                    = Параметры.addresstownshipED;
	Город                    = Параметры.addresscityED;
	НаселенныйПункт          = Параметры.addresslocalityED;
	Улица                    = Параметры.addressstreetED;
	Дом                      = Параметры.addressbuildingED;
	Корпус                   = Параметры.addresshousingED;
	Квартира                 = Параметры.addressapartmentED;
	Телефон                  = Параметры.addressphoneED;
	Организация              = Параметры.agencyED;
	ИНН                      = Параметры.innED;
	КПП                      = Параметры.kppED;
	ОГРН                     = Параметры.ogrnED;
	КодНалоговогоОргана      = Параметры.codeimnsED;
	Фамилия                  = Параметры.lastnameED;
	Имя                      = Параметры.firstnameED;
	Отчество                 = Параметры.middlenameED;
	ИдентификаторОрганизации = Параметры.identifierTaxcomED;
	
	Если СтатусФормы <> "show" Тогда
		СертификатЭП = Параметры.IDCertificateED;
	КонецЕсли;
	
	СформироватьАдрес();
	
	ЮрФизЛицо = ?(ПустаяСтрока(ЮрФизЛицо), "ЮрЛицо", ЮрФизЛицо);
	
	НастройкиПоЮрФизЛицу();
	
КонецПроцедуры

// Процедура настройки доступности элементов формы
// в зависимости от переключателя ЮрФизЛицо.
&НаСервере
Процедура НастройкиПоЮрФизЛицу()
	
	Если ЮрФизЛицо = "ЮрЛицо" Тогда
		Элементы.КПП.Доступность = Истина;
		Элементы.КПП.АвтоОтметкаНезаполненного = Истина;
		Элементы.ОГРН.АвтоОтметкаНезаполненного = Истина;
	Иначе
		Элементы.КПП.Доступность = Ложь;
		Элементы.КПП.АвтоОтметкаНезаполненного  = Ложь;
		Элементы.ОГРН.АвтоОтметкаНезаполненного = Ложь;
		КПП = "";
	КонецЕсли;
	
КонецПроцедуры

// Выполняет формирование строки адреса по реквизитам адреса
&НаСервере
Процедура СформироватьАдрес()
	
	Адр = "";
	
	ДобавитьПодстроку(Адр, Индекс);
	ДобавитьПодстроку(Адр, Регион);
	ДобавитьПодстроку(Адр, КодРегиона, "регион ");
	ДобавитьПодстроку(Адр, Район);
	ДобавитьПодстроку(Адр, Город);
	ДобавитьПодстроку(Адр, НаселенныйПункт);
	ДобавитьПодстроку(Адр, Улица);
	ДобавитьПодстроку(Адр, Дом     , "д. ");
	ДобавитьПодстроку(Адр, Корпус  , "корп. ");
	ДобавитьПодстроку(Адр, Квартира, "кв. ");
	
	Адрес = Адр;
	
КонецПроцедуры

// Процедура добавления подстроки к строке
// Параметры:
// - ИсходнаяСтрока - Строка - исходная строка;
// - Подстрока      - Строка - строка, которая должна быть добавлена в конец исходной строки;
// - Префикс        - Строка - строка, которая добавляется перед подстрокой;
// - Разделитель    - строка - строка, которая служит разделителем между строкой и подстрокой.
//
&НаСервере
Процедура ДобавитьПодстроку(ИсходнаяСтрока, Знач Подстрока, Префикс = "", Разделитель = ", ")
	
	Если НЕ ПустаяСтрока(ИсходнаяСтрока) И НЕ ПустаяСтрока(Подстрока) Тогда
		ИсходнаяСтрока = ИсходнаяСтрока + Разделитель;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Подстрока) Тогда
		ИсходнаяСтрока = ИсходнаяСтрока + Префикс + Подстрока;
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму выбора адреса в модальном режиме и возвращает
// реквизиты адреса в виде структуры с соответствующими полями.
//
// Параметры:
// - ТолькоДляПросмотра (Булево): Истина - открыть форму выбора адреса только для просмотра.
//
// Возвращаемое значение: Структура с полями - реквизитами адреса;
//						  Неопределено, если на форме адреса при закрытии не была нажата кнопка "ОК".
//
&НаКлиенте
Процедура ВыбратьАдрес(ТолькоДляПросмотра = Ложь)
	
	ПараметрыФормы = Новый Структура("ТолькоПросмотр", ТолькоДляПросмотра);
	
	Если ТолькоДляПросмотра Тогда
		ОповещениеОЗакрытии = Неопределено;
	Иначе
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПриВыбореАдреса", ЭтотОбъект);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Индекс"    , Индекс);
	ПараметрыФормы.Вставить("Регион"    , Регион);
	ПараметрыФормы.Вставить("Район"     , Район);
	ПараметрыФормы.Вставить("Город"     , Город);
	ПараметрыФормы.Вставить("НасПункт"  , НаселенныйПункт);
	ПараметрыФормы.Вставить("Улица"     , Улица);
	ПараметрыФормы.Вставить("Дом"       , Дом);
	ПараметрыФормы.Вставить("Корпус"    , Корпус);
	ПараметрыФормы.Вставить("Квартира"  , Квартира);
	ПараметрыФормы.Вставить("КодРегиона", КодРегиона);
	
	ФормаВводаАдреса = ОткрытьФорму("Обработка.Подключение1СТакском.Форма.АдресУчастникаОбменаЭД",
		ПараметрыФормы,
		,
		,
		,
		,
		ОповещениеОЗакрытии);
	
	ФормаВводаАдреса.КонтекстВзаимодействия = КонтекстВзаимодействия;
	Подключение1СТакскомКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ФормаВводаАдреса);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореАдреса(ПараметрыАдреса, ДопПараметры) Экспорт
	
	Если ТипЗнч(ПараметрыАдреса) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	// Установка модифицированности по переданным данным
	Если НЕ ЭтотОбъект.Модифицированность Тогда
		Если    Индекс          <> ПараметрыАдреса.Индекс
			ИЛИ Регион          <> ПараметрыАдреса.Регион
			ИЛИ Район           <> ПараметрыАдреса.Район
			ИЛИ Город           <> ПараметрыАдреса.Город
			ИЛИ НаселенныйПункт <> ПараметрыАдреса.НаселенныйПункт
			ИЛИ Улица           <> ПараметрыАдреса.Улица
			ИЛИ Дом             <> ПараметрыАдреса.Дом
			ИЛИ Корпус          <> ПараметрыАдреса.Корпус
			ИЛИ Квартира        <> ПараметрыАдреса.Квартира
			ИЛИ КодРегиона      <> ПараметрыАдреса.КодРегиона Тогда
			
			ЭтотОбъект.Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Если адрес изменен, то применение изменений
	Индекс          = ПараметрыАдреса.Индекс;
	Регион          = ПараметрыАдреса.Регион;
	Район           = ПараметрыАдреса.Район;
	Город           = ПараметрыАдреса.Город;
	НаселенныйПункт = ПараметрыАдреса.НаселенныйПункт;
	Улица           = ПараметрыАдреса.Улица;
	Дом             = ПараметрыАдреса.Дом;
	Корпус          = ПараметрыАдреса.Корпус;
	Квартира        = ПараметрыАдреса.Квартира;
	КодРегиона      = ПараметрыАдреса.КодРегиона;
	
	СформироватьАдрес();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОтветеНаВопросОЗакрытииМодифицированнойФормы(РезультатВопроса, ДопПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

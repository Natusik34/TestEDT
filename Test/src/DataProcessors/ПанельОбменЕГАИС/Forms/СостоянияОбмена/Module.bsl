
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Организации.Очистить();
	Если Параметры.Свойство("Организации") И ЗначениеЗаполнено(Параметры.Организации) Тогда
		Если ТипЗнч(Параметры.Организации) = Тип("Массив") Тогда
			Организации.ЗагрузитьЗначения(Параметры.Организации);
		ИначеЕсли ТипЗнч(Параметры.Организации) = Тип("СписокЗначений") Тогда
			Организации.ЗагрузитьЗначения(Параметры.Организации.ВыгрузитьЗначения());
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьСписокПроблем();
	
	СобытияФормИС.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ХранитьФайлыВТомахНаДиске" Тогда
		
		Если ПравоДоступаНастройкиРаботыСФайлами() Тогда
			ОткрытьФорму("Обработка.ПанельАдминистрированияБСП.Форма.НастройкиРаботыСФайлами");
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Вам запрещено выполнение данной операции'"));
		КонецЕсли;
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ЕстьСообщенияОжидающиеОтправки" Тогда
		
		ПараметрыОткрытияФормы = Неопределено;
		Если Организации.Количество() > 0 Тогда
			
			Отбор = Новый Структура;
			Отбор.Вставить("ОрганизацияЕГАИС", Организации.ВыгрузитьЗначения());
			
			ПараметрыОткрытияФормы = Новый Структура;
			ПараметрыОткрытияФормы.Вставить("Отбор", Отбор);
			
		КонецЕсли;
		
		ОткрытьФорму("РегистрСведений.ОчередьПередачиДанныхЕГАИС.ФормаСписка", ПараметрыОткрытияФормы);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "НастроитьАвтоматическийОбмен" Тогда
		
		ОткрытьФорму("Обработка.ПанельАдминистрированияЕГАИС.Форма.НастройкиЕГАИС");
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ВыполнитьОбмен" Тогда
		
		ИнтеграцияЕГАИСКлиент.ВыполнитьОбмен(
			ИнтеграцияЕГАИСКлиент.ОрганизацииЕГАИСДляОбмена(
				ВладелецФормы),,
			ВладелецФормы.УникальныйИдентификатор);
		
	Иначе
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Неизвестная ссылка: %1'"),
			НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПравоДоступаНастройкиРаботыСФайлами()
	
	Возврат ИнтеграцияИС.ПравоДоступаПанельАдминистрированиеБСП();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокПроблем();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписокПроблем()
	
	РезультатыЗапроса = ИнтеграцияЕГАИС.СостояниеОбмена(Организации);
	
	ПроверитьХранениеФайловВТомахНаДиске();
	ПроверитьСообщенияОжидающиеОтправки(РезультатыЗапроса);
	ПроверитьНастройкиАвтоматическогоОбмена();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьХранениеФайловВТомахНаДиске()
	
	ИдентификаторПроблемы = "ХранитьФайлыВТомахНаДиске";
	ИмяЭлемента           = "ХранитьФайлыВТомахНаДиске";
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
		И Не ОбщегоНазначения.РазделениеВключено()
		И Не ИнтеграцияИС.ХранитьФайлыВТомахНаДиске();
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='Рекомендуется настроить хранение файлов в томах на диске'"),,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru='Файлы обмена могут занимать значительный объем данных в базе.
			|Для уменьшения объема базы данных, файлы необходимо хранить в томах на диске.'");
		
		Если Не ИнтеграцияИС.ПравоДоступаПанельАдминистрированиеБСП() Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru='У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСообщенияОжидающиеОтправки(РезультатыЗапроса)
	
	ИдентификаторПроблемы = "ЕстьСообщенияОжидающиеОтправки";
	ИмяЭлемента           = "ЕстьСообщенияОжидающиеОтправки";
	
	Выборка = РезультатыЗапроса[ИдентификаторПроблемы].Выбрать();
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Выборка.Количество() > 0;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Выборка.Следующий();
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			СтрШаблон(
				НСтр("ru='Есть сообщения ожидающие отправки (%1)'"),
				Выборка.КоличествоСообщений),,,,
			ИдентификаторПроблемы);
		
		СтрокаЗаголовка = Новый Массив;
		СтрокаЗаголовка.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru = 'Не все подготовленные для отправки сообщения доставлены в ЕГАИС.
					|Рекомендуется'")));
		СтрокаЗаголовка.Добавить(" ");
		СтрокаЗаголовка.Добавить(
			Новый ФорматированнаяСтрока(
				Нстр("ru='выполнить обмен'"),,,, "ВыполнитьОбмен"));
		СтрокаЗаголовка.Добавить(".");
		
		Элементы[ИмяЭлемента + "РасширеннаяПодсказка"].Заголовок = Новый ФорматированнаяСтрока(СтрокаЗаголовка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНастройкиАвтоматическогоОбмена()
	
	ИдентификаторПроблемы = "НастроитьАвтоматическийОбмен";
	
	ЗаданиеАвтоматическогоОбменаВключено                         = Истина;
	ЗаданиеНастройкиСверткиРегистраСоответствиеНоменклатурыЕГАИС = Истина;
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		
		Отбор = Новый Структура;
		Отбор.Вставить("Метаданные",    "ОбработкаОтветовЕГАИС");
		Отбор.Вставить("Использование", Истина);
		
		УстановитьПривилегированныйРежим(Истина);
		ЗаданиеАвтоматическогоОбменаВключено = РегламентныеЗаданияСервер.НайтиЗадания(Отбор).Количество() > 0;
		УстановитьПривилегированныйРежим(Ложь);
		
		Если ИнтеграцияИС.СерииИспользуются() Тогда
			Отбор = Новый Структура;
			Отбор.Вставить("Метаданные",    "СверткаРегистраСоответствиеНоменклатурыЕГАИС");
			Отбор.Вставить("Использование", Истина);
			
			УстановитьПривилегированныйРежим(Истина);
			ЗаданиеНастройкиСверткиРегистраСоответствиеНоменклатурыЕГАИС = РегламентныеЗаданияСервер.НайтиЗадания(Отбор).Количество() > 0;
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
	// НастроитьАвтоматическийОбмен
	ИмяЭлемента = "НастроитьАвтоматическийОбмен";
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не ЗаданиеАвтоматическогоОбменаВключено;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='Рекомендуется настроить автоматический обмен с ЕГАИС'"),,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru = 'Выполнение обмена может занять значительное время.
		                            |Автоматическое выполнение обмена по расписанию позволит не тратить время на ожидание завершение обмена.'");
		
		Если Не ПравоДоступа("Изменение", Метаданные.Константы.ИспользоватьАвтоматическуюОтправкуПолучениеДанныхЕГАИС) Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru = 'У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
	// СверткаРегистраСоответствиеНоменклатурыЕГАИС
	ИмяЭлемента = "СверткаРегистраСоответствиеНоменклатурыЕГАИС";
	
	Элементы["Группа" + ИмяЭлемента].Видимость = Не ЗаданиеНастройкиСверткиРегистраСоответствиеНоменклатурыЕГАИС;
	
	Если Элементы["Группа" + ИмяЭлемента].Видимость Тогда
		
		Элементы[ИмяЭлемента].Заголовок = Новый ФорматированнаяСтрока(
			НСтр("ru='Рекомендуется настроить свертку регистра соответствия номенклатуры ЕГАИС'"),,,,
			ИдентификаторПроблемы);
		
		ТекстПодсказки = НСтр("ru = 'Сворачивает остатки по сериям и записям складского журнала регистра соответствие номенклатуры.'");
		
		Если Не ПравоДоступа("Изменение", Метаданные.Константы.ИспользоватьАвтоматическуюСверткуРегистраСоответствиеНоменклатурыЕГАИС) Тогда
			
			Элементы[ИмяЭлемента].Доступность = Ложь;
			ТекстПодсказки = ТекстПодсказки + Символы.ПС
				+ НСтр("ru = 'У Вас недостачно прав для выполнения данной операции, обратитесь к администратору.'");
			
		КонецЕсли;
		
		Элементы[ИмяЭлемента].РасширеннаяПодсказка.Заголовок = ТекстПодсказки;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
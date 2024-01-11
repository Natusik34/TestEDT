///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	Статус = Перечисления.СтатусыМЧД.Черновик;
	УстановившийСтатус = Неопределено;
	СтатусУстановленВручную = Ложь;
	НомерДоверенности = Неопределено;
	ФайлДоверенности = Неопределено;
	Верна = Ложь;
	СтатусВернаУстановленВручную = Ложь;
	УстановившийСтатусВерна = Неопределено;
	Подписана = Ложь;
	ДатаПроверки = Неопределено;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		Наименование = Справочники.МашиночитаемыеДоверенности.АвтоНаименование(ЭтотОбъект);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
		
	Если Не Ссылка.Пустая() Тогда
		ОбновитьСтатус();
	Иначе
		ДополнительныеСвойства.Вставить("ОбновитьСтатус");
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.МашиночитаемыеДоверенностиПредставителиИДоверители.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.МашиночитаемаяДоверенность.Установить(Ссылка);
	
	Найдено = Представители.НайтиСтроки(Новый Структура("ИдентификаторРодителя",
		Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")));
	
	Для Каждого СтрокаОрганизация Из Найдено Цикл
		
		РеквизитыОрганизации = СтрокаОрганизация.ПредставительРеквизиты.Получить();
		
		Если РеквизитыОрганизации.ЭтоФизическоеЛицо Тогда
			ДобавитьСтрокуПредставителя(НаборЗаписей, СтрокаОрганизация.Представитель, РеквизитыОрганизации);
		Иначе
			НайденоФизическиеЛица = Представители.НайтиСтроки(Новый Структура("ИдентификаторРодителя",
				СтрокаОрганизация.Идентификатор));
			Для Каждого СтрокаФизическоеЛицо Из НайденоФизическиеЛица Цикл
				РеквизитыФизическогоЛица = СтрокаФизическоеЛицо.ПредставительРеквизиты.Получить();
				ДобавитьСтрокуПредставителя(НаборЗаписей, СтрокаФизическоеЛицо.Представитель,
					РеквизитыФизическогоЛица, СтрокаОрганизация.Представитель, РеквизитыОрганизации);
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	Найдено = Доверители.НайтиСтроки(Новый Структура("ИдентификаторРодителя",
	Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")));
	
	Для Каждого СтрокаОрганизация Из Найдено Цикл
		РеквизитыОрганизации = СтрокаОрганизация.ДоверительРеквизиты.Получить();
	
		Если РеквизитыОрганизации.ЭтоФизическоеЛицо Тогда
			ДобавитьСтрокуДоверителя(НаборЗаписей, СтрокаОрганизация.Доверитель, РеквизитыОрганизации, Ложь);
		Иначе
			
			НайденоУправляющиеКомпании = Доверители.НайтиСтроки(Новый Структура("ИдентификаторРодителя",
				СтрокаОрганизация.Идентификатор));
				
			Для Каждого СтрокаУправляющаяКомпания Из НайденоУправляющиеКомпании Цикл
				
				СовместныеПолномочияЛицаДоверителя = СтрокаУправляющаяКомпания.СовместныеПолномочия;
				РеквизитыУправляющейКомпании = СтрокаУправляющаяКомпания.ДоверительРеквизиты.Получить();
				
				Если РеквизитыУправляющейКомпании.ЭтоФизическоеЛицо Тогда
					ДобавитьСтрокуДоверителя(НаборЗаписей, СтрокаУправляющаяКомпания.Доверитель, РеквизитыУправляющейКомпании,
						СовместныеПолномочияЛицаДоверителя, СтрокаОрганизация.Доверитель, РеквизитыОрганизации);
				Иначе
					
					НайденоФизическиеЛица = Доверители.НайтиСтроки(Новый Структура("ИдентификаторРодителя",
						СтрокаУправляющаяКомпания.Идентификатор));
					
					Для Каждого СтрокаФизическоеЛицо Из НайденоФизическиеЛица Цикл
							
						РеквизитыФизическогоЛица = СтрокаФизическоеЛицо.ДоверительРеквизиты.Получить();
						ДобавитьСтрокуДоверителя(НаборЗаписей, СтрокаФизическоеЛицо.Доверитель, РеквизитыФизическогоЛица,
							СовместныеПолномочияЛицаДоверителя, СтрокаОрганизация.Доверитель, РеквизитыОрганизации,
							СтрокаУправляющаяКомпания.Доверитель);
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	НаборЗаписей.Записать();
	
	Если ДополнительныеСвойства.Свойство("ОбновитьСтатус") Тогда
		ОбновитьСтатус();
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьСтатус()
	
	ТехническийСтатус = МашиночитаемыеДоверенностиФНССлужебный.РассчитатьТехническийСтатус(ЭтотОбъект);
	НовыйСтатус = МашиночитаемыеДоверенностиФНССлужебныйКлиентСервер.РасчетныйСтатусДокумента(ТехническийСтатус, Верна);
	Если НовыйСтатус <> Статус Тогда
		Статус = НовыйСтатус;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьСтрокуПредставителя(НаборЗаписей, Представитель, РеквизитыФизическогоЛица,
	Организация = Неопределено, РеквизитыОрганизации = Неопределено)
	
	НоваяЗапись = НаборЗаписей.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяЗапись, РеквизитыФизическогоЛица);
	
	НоваяЗапись.МашиночитаемаяДоверенность = Ссылка;
	НоваяЗапись.ТипУчастника = Перечисления.ТипыУчастниковМЧД.Представитель;
	НоваяЗапись.СовместныеПолномочия = СовместныеПолномочия;
	
	НоваяЗапись.ФизическоеЛицо = Представитель;
	НоваяЗапись.ФИО = ФИО(РеквизитыФизическогоЛица);
	НоваяЗапись.СНИЛС = МашиночитаемыеДоверенностиФНССлужебныйКлиентСервер.ТолькоЦифры(РеквизитыФизическогоЛица.СтраховойНомерПФР);
	
	Если РеквизитыОрганизации <> Неопределено Тогда
		ЗаполнитьРеквизитыОрганизации(НоваяЗапись, Организация, РеквизитыОрганизации);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьСтрокуДоверителя(НаборЗаписей, Доверитель, РеквизитыФизическогоЛица, СовместныеПолномочияЛицаБезДоверенности,
	Организация = Неопределено, РеквизитыОрганизации = Неопределено, УправляющаяКомпания = Неопределено)
	
	НоваяЗапись = НаборЗаписей.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяЗапись, РеквизитыФизическогоЛица);
	
	НоваяЗапись.МашиночитаемаяДоверенность = Ссылка;
	НоваяЗапись.ТипУчастника = Перечисления.ТипыУчастниковМЧД.Доверитель;
	НоваяЗапись.СовместныеПолномочия = СовместныеПолномочияЛицаБезДоверенности;
	
	НоваяЗапись.ФизическоеЛицо = Доверитель;
	НоваяЗапись.ФИО = ФИО(РеквизитыФизическогоЛица);
	НоваяЗапись.СНИЛС = МашиночитаемыеДоверенностиФНССлужебныйКлиентСервер.ТолькоЦифры(РеквизитыФизическогоЛица.СтраховойНомерПФР);
	
	Если РеквизитыОрганизации <> Неопределено Тогда
		ЗаполнитьРеквизитыОрганизации(НоваяЗапись, Организация, РеквизитыОрганизации);
	КонецЕсли;
	
	Если УправляющаяКомпания <> Неопределено Тогда
		НоваяЗапись.УправляющаяКомпания = УправляющаяКомпания;
	КонецЕсли;
	
КонецПроцедуры

Функция ФИО(Реквизиты)
	
	Массив = Новый Массив;
	Массив.Добавить(Реквизиты.Фамилия);
	Массив.Добавить(Реквизиты.Имя);
	Если ЗначениеЗаполнено(Реквизиты.Отчество) Тогда
		Массив.Добавить(Реквизиты.Отчество);
	КонецЕсли;
	
	Возврат СтрСоединить(Массив, " ");
	
КонецФункции

Процедура ЗаполнитьРеквизитыОрганизации(НоваяЗапись, Организация, РеквизитыОрганизации)

	НоваяЗапись.Организация = Организация;
	ЗаполнитьЗначенияСвойств(НоваяЗапись, РеквизитыОрганизации);
	Если РеквизитыОрганизации.ЭтоИндивидуальныйПредприниматель Тогда
		НоваяЗапись.ИНН = Неопределено;
		НоваяЗапись.ИННФЛ = РеквизитыОрганизации.ИНН;
	КонецЕсли;
	НоваяЗапись.НаименованиеОрганизации = РеквизитыОрганизации.НаименованиеПолное;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
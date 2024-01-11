///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция НастройкиТранспорта(Знач Корреспондент) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		ВызватьИсключение НСтр("ru = 'Не определен менеджер настроек транспорта обмена сообщениями.'");
	КонецЕсли;
	
	ИмяРегистраНастроекТранспортаОбменаСообщениями = "НастройкиТранспортаОбменаСообщениями";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	"""" КАК FILEКаталогОбменаИнформацией,
	|	"""" КАК FTPСоединениеПуть,
	|	НастройкиТранспортаОбластиДанных.КаталогОбменаИнформацией КАК ОтносительныйКаталогОбменаИнформацией,
	|	НастройкиТранспортаОбластейДанных.FILEКаталогОбменаИнформацией КАК FILEОбщийКаталогОбменаИнформацией,
	|	НастройкиТранспортаОбластейДанных.FILEСжиматьФайлИсходящегоСообщения,
	|	НастройкиТранспортаОбластейДанных.FTPСоединениеПуть КАК FTPОбщийКаталогОбменаИнформацией,
	|	НастройкиТранспортаОбластейДанных.FTPСжиматьФайлИсходящегоСообщения,
	|	НастройкиТранспортаОбластейДанных.FTPСоединениеМаксимальныйДопустимыйРазмерСообщения,
	|	НастройкиТранспортаОбластейДанных.FTPСоединениеПассивноеСоединение,
	|	НастройкиТранспортаОбластейДанных.FTPСоединениеПользователь,
	|	НастройкиТранспортаОбластейДанных.FTPСоединениеПорт,
	|	НастройкиТранспортаОбластейДанных.ВидТранспортаСообщенийОбменаПоУмолчанию,
	|	НастройкиТранспортаОбластейДанных.КонечнаяТочкаКорреспондента,
	|	НастройкиТранспорта.АдресВебСервиса КАК WSURLВебСервиса,
	|	НастройкиТранспорта.ИмяПользователя КАК WSИмяПользователя,
	|	"""" КАК WSОбластьДанныхКорреспондента,
	|	"""" КАК WSКонечнаяТочкаКорреспондента
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбменаОбластиДанных КАК НастройкиТранспортаОбластиДанных
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиТранспортаОбменаОбластейДанных КАК НастройкиТранспортаОбластейДанных
	|		ПО (НастройкиТранспортаОбластейДанных.КонечнаяТочкаКорреспондента = НастройкиТранспортаОбластиДанных.КонечнаяТочкаКорреспондента)
	|		ЛЕВОЕ СОЕДИНЕНИЕ #ТаблицаНастройкиТранспорта КАК НастройкиТранспорта
	|		ПО (НастройкиТранспорта.КонечнаяТочка = НастройкиТранспортаОбластиДанных.КонечнаяТочкаКорреспондента)
	|ГДЕ
	|	НастройкиТранспортаОбластиДанных.Корреспондент = &Корреспондент";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ТаблицаНастройкиТранспорта", "РегистрСведений." + ИмяРегистраНастроекТранспортаОбменаСообщениями);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Корреспондент", Корреспондент);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = ОбменДаннымиСлужебный.РезультатЗапросаВСтруктуру(РезультатЗапроса);
	
	УстановитьПривилегированныйРежим(Истина);
	Пароли = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Результат.КонечнаяТочкаКорреспондента,
		"FTPСоединениеПарольОбластейДанных,WSПароль, ПарольАрхиваСообщенияОбменаОбластейДанных", Истина);
	УстановитьПривилегированныйРежим(Ложь);
	
	Результат.Вставить("WSПароль", Пароли.WSПароль);
	Результат.Вставить("FTPСоединениеПароль", Пароли.FTPСоединениеПарольОбластейДанных);
	Результат.Вставить("ПарольАрхиваСообщенияОбмена", Пароли.ПарольАрхиваСообщенияОбменаОбластейДанных);
	
	Результат.FILEКаталогОбменаИнформацией = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		Результат.FILEОбщийКаталогОбменаИнформацией,
		Результат.ОтносительныйКаталогОбменаИнформацией);
	
	Результат.FTPСоединениеПуть = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		Результат.FTPОбщийКаталогОбменаИнформацией,
		Результат.ОтносительныйКаталогОбменаИнформацией);
	
	Результат.Вставить("ИспользоватьВременныйКаталогДляОтправкиИПриемаСообщений", Истина);
	
	Если Результат.ВидТранспортаСообщенийОбменаПоУмолчанию = Перечисления.ВидыТранспортаСообщенийОбмена.FTP Тогда
		
		ПараметрыFTP = ОбменДаннымиСервер.FTPИмяСервераИПуть(Результат.FTPСоединениеПуть);
		
		Результат.Вставить("FTPСервер", ПараметрыFTP.Сервер);
		Результат.Вставить("FTPПуть",   ПараметрыFTP.Путь);
		
	Иначе
		Результат.Вставить("FTPСервер", "");
		Результат.Вставить("FTPПуть",   "");
	КонецЕсли;
	
	ОбменДаннымиСлужебный.ДополнитьНастройкиТранспортаКоличествомЭлементовВТранзакции(Результат);
	
	Возврат Результат;
КонецФункции

Функция НастройкиТранспортаWS(Знач Корреспондент) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		ВызватьИсключение НСтр("ru = 'Не определен менеджер настроек транспорта обмена сообщениями.'");
	КонецЕсли;
	
	ИмяРегистраНастроекТранспортаОбменаСообщениями = "НастройкиТранспортаОбменаСообщениями";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НастройкиТранспортаОбластиДанных.КонечнаяТочкаКорреспондента КАК КонечнаяТочкаКорреспондента
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбменаОбластиДанных КАК НастройкиТранспортаОбластиДанных
	|ГДЕ
	|	НастройкиТранспортаОбластиДанных.Корреспондент = &Корреспондент");
	Запрос.УстановитьПараметр("Корреспондент", Корреспондент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	КонечнаяТочка = Выборка.КонечнаяТочкаКорреспондента;
	
	МенеджерНастройкиТранспорта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("РегистрСведений."
		+ ИмяРегистраНастроекТранспортаОбменаСообщениями);
	СтруктураНастроек = МенеджерНастройкиТранспорта.НастройкиТранспортаWS(КонечнаяТочка);
	
	Если Не ЗначениеЗаполнено(СтруктураНастроек.WSURLВебСервиса) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не заданы настройки подключения веб-сервиса для корреспондента ""%1"".'"),
			Строка(Корреспондент));
	КонецЕсли;
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Процедура обновляет запись в регистре по переданным значениям структуры
//
Процедура ОбновитьЗапись(СтруктураЗаписи) Экспорт
	
	ОбменДаннымиСлужебный.ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "НастройкиТранспортаОбменаОбластиДанных");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

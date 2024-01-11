#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗапросМетодаИнтефрейсаСОбработкой(ПараметрыОбработки) Экспорт

	Если Не ЭлектроннаяПодпись.ИспользоватьЭлектронныеПодписи() Тогда
		ПараметрыОбработки.ЕстьОшибки  = Истина;
		ПараметрыОбработки.ТекстОшибки = НСтр("ru = 'Подсистема электронной подписи отключена.'");
		Возврат;
	КонецЕсли;
	
	ЗаполнитьОрганизациюПараметровОбработкиПоКлючуСессии(ПараметрыОбработки);
	
	Если Не ЗначениеЗаполнено(ПараметрыОбработки.Организация)
		И ПараметрыОбработки.ОрганизацияПоСертификатам = Неопределено Тогда
		ПараметрыОбработки.ОрганизацияПоСертификатам = Истина;
		Возврат;
	КонецЕсли;
	
	ТребуетсяОбновлениеКлючаСессии = Ложь;
	ТекстОшибки                    = Неопределено;
	ДанныеДляОбработки             = Неопределено;
	
	ДоступныеМетодыИнтерфейса = ИнтерфейсИСМПКлиентСервер.ДоступныеМетодыИнтерфейса();
	
	Если ПараметрыОбработки.ИмяОбработчика = ДоступныеМетодыИнтерфейса.ЕмкостьУпаковкиПоGTIN Тогда
		
		ТаблицаНоменкклатуры = Новый ТаблицаЗначений();
		ТаблицаНоменкклатуры.Колонки.Добавить("Номенклатура",   Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
		ТаблицаНоменкклатуры.Колонки.Добавить("Характеристика", Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
		
		НоваяСтрока = ТаблицаНоменкклатуры.Добавить();
		НоваяСтрока.Номенклатура = ПараметрыОбработки.Параметры.Номенклатура;
		МассивGTIN = Новый Массив();
		ШтрихкодированиеИС.ЗаполнитьПроверяемыеGTIN(ТаблицаНоменкклатуры, МассивGTIN, Новый Соответствие(),, Ложь);
		
		Если МассивGTIN.Количество() = 0 Тогда
			
			ТекстОшибки = НСтр("ru = 'Не найдено GTIN для получения емкости упаковки по данным ГИС МТ.'");
			
		Иначе
			
			Результат = ИнтерфейсИСМП.ДанныеПродукцииПоШтрихкодуEAN(
				МассивGTIN,,
				ПараметрыОбработки.Организация);
			
			ТребуетсяОбновлениеКлючаСессии = Результат.ТребуетсяОбновлениеКлючаСессии;
			ТекстОшибки                    = Результат.ТекстОшибки;
			ДанныеДляОбработки             = Результат.ДанныеПродукцииПоШтрихкодуEAN;
			
		КонецЕсли;
	
	ИначеЕсли ПараметрыОбработки.ИмяОбработчика = ДоступныеМетодыИнтерфейса.МестаОсуществленияДеятельности Тогда
		
		Результат = ИнтерфейсИСМП.МестаОсуществленияДеятельности(ПараметрыОбработки.Организация, ПараметрыОбработки.ВидПродукции);
		
		ТребуетсяОбновлениеКлючаСессии = Результат.ТребуетсяОбновлениеКлючаСессии;
		ТекстОшибки                    = Результат.ТекстОшибки;
		ДанныеДляОбработки             = Результат.МестаОсуществленияДеятельности;
	
	Иначе
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Внутренняя ошибка. Не описан метод интерфейса с запросом ключа авторизации %1'"),
			ПараметрыОбработки.ИмяОбработчика);
	КонецЕсли;
	
	Если ТребуетсяОбновлениеКлючаСессии Тогда
		
		ПараметрыОбработки.ТребуетсяОбновлениеКлючаСессии = Истина;
	
	ИначеЕсли ЗначениеЗаполнено(ТекстОшибки) Тогда
		
		ПараметрыОбработки.ЕстьОшибки  = Истина;
		ПараметрыОбработки.ТекстОшибки = ТекстОшибки;
		
	Иначе
		
		Если ПараметрыОбработки.ИмяОбработчика = ДоступныеМетодыИнтерфейса.ЕмкостьУпаковкиПоGTIN Тогда
			ПараметрыОбработки.Результат = ОбработкаРезультатаЕмкостьУпаковкиПоGTIN(ДанныеДляОбработки);
		ИначеЕсли ПараметрыОбработки.ИмяОбработчика = ДоступныеМетодыИнтерфейса.МестаОсуществленияДеятельности Тогда
			ПараметрыОбработки.Результат = ОбработкаМестаОсуществленияДеятельности(ДанныеДляОбработки);
		Иначе
			ВызватьИсключение НСтр("ru = 'Внутренняя ошибка. Не описан метод интерфейса с запросом ключа авторизации (после авторизации).'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСокращеннуюИнформациюПоКМ(ПолныйКодМаркировки, НормализованныйШтрихкод, ВидПродукции, ПараметрыСканирования) Экспорт
	
	СтруктураВозврата = Новый Структура();
	СтруктураВозврата.Вставить("ИдентификаторЗапросаГИСМТ",        "");
	СтруктураВозврата.Вставить("ДатаВремяПолученияИдентификатора", "");
	СтруктураВозврата.Вставить("ОписаниеОшибки",                   Неопределено);
	СтруктураВозврата.Вставить("ЧастичноеВыбытиеОстаток",          Неопределено);
	
	ТаблицаМаркировки = Новый ТаблицаЗначений();
	ТаблицаМаркировки.Колонки.Добавить("ПолныйКодМаркировки",     ОбщегоНазначения.ОписаниеТипаСтрока(255));
	ТаблицаМаркировки.Колонки.Добавить("НормализованныйШтрихкод", ОбщегоНазначения.ОписаниеТипаСтрока(255));
	ТаблицаМаркировки.Колонки.Добавить("ВидПродукции",            Новый ОписаниеТипов("ПеречислениеСсылка.ВидыПродукцииИС"));
	ТаблицаМаркировки.Колонки.Добавить("ТекстОшибки",             ОбщегоНазначения.ОписаниеТипаСтрока(0));
	
	НоваяСтрокаДанных = ТаблицаМаркировки.Добавить();
	НоваяСтрокаДанных.ПолныйКодМаркировки     = ПолныйКодМаркировки;
	НоваяСтрокаДанных.НормализованныйШтрихкод = НормализованныйШтрихкод;
	НоваяСтрокаДанных.ВидПродукции            = ВидПродукции;
	
	Результат = ИнтерфейсИСМП.СокращеннаяИнформацияПоКМПриРозничнойПродаже(ТаблицаМаркировки, ПараметрыСканирования.Организация);
	
	РезультатПоСтроке = Результат.СтатусыКодовМаркировки.Получить(НоваяСтрокаДанных);
	
	Если Не РезультатПоСтроке = Неопределено Тогда
	
		СтруктураВозврата.ИдентификаторЗапросаГИСМТ        = РезультатПоСтроке.ИдентификаторЗапросаГИСМТ;
		СтруктураВозврата.ДатаВремяПолученияИдентификатора = РезультатПоСтроке.ДатаВремяПолученияИдентификатора;
		СтруктураВозврата.ЧастичноеВыбытиеОстаток          = РезультатПоСтроке.ЧастичноеВыбытиеОстаток;
		СтруктураВозврата.ОписаниеОшибки                   = Результат.ТекстОшибки;
		
	Иначе
		
		СтруктураВозврата.ОписаниеОшибки            = НСтр("ru = 'Код маркировки не найден в ГИС МТ.'");
		
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

Процедура ПолучитьСокращеннуюИнформациюПоКМДлительнаяОперация(Параметры, АдресРезультата) Экспорт

	ДанныеИдентификаторов = Новый Соответствие();

	КоличествоДанных     = Параметры.МассивКМ.Количество();
	КоличествоОбработано = 0;
	
	Шаблон = НСтр("ru = 'Обработано %1 из %2 кодов маркировки.'");
	
	Для Каждого КодМаркировки Из Параметры.МассивКМ Цикл
		
		СтруктураКодаМаркировки = Новый Структура("ПолныйКодМаркировки, НормализованныйКодМаркировки, ВидПродукции");
		ЗаполнитьЗначенияСвойств(СтруктураКодаМаркировки, КодМаркировки);
		
		Если Не ЗначениеЗаполнено(КодМаркировки.ПолныйКодМаркировки)
			Или Не ИнтеграцияИСМПКлиентСерверПовтИсп.ПродукцияПодлежитОбязательнойОнлайнПроверкеПередРозничнойПродажей(СтруктураКодаМаркировки.ВидПродукции) Тогда
			
			КоличествоОбработано = КоличествоОбработано + 1;
			ТекстПрогресса = СтрШаблон(Шаблон, КоличествоОбработано, КоличествоДанных);
			ДлительныеОперации.СообщитьПрогресс(КоличествоОбработано, ТекстПрогресса);
			
			Продолжить;
			
		КонецЕсли;
		
		СтруктураДанныхГИСМТ = ПолучитьСокращеннуюИнформациюПоКМ(СтруктураКодаМаркировки.ПолныйКодМаркировки,
			СтруктураКодаМаркировки.НормализованныйКодМаркировки,
			СтруктураКодаМаркировки.ВидПродукции,
			Параметры.ПараметрыСканирования);
			
		ДанныеИдентификаторов.Вставить(СтруктураКодаМаркировки.ПолныйКодМаркировки, СтруктураДанныхГИСМТ);
		
		КоличествоОбработано = КоличествоОбработано + 1;
		
		ТекстПрогресса = СтрШаблон(Шаблон, КоличествоОбработано, КоличествоДанных);
		ДлительныеОперации.СообщитьПрогресс(КоличествоОбработано, ТекстПрогресса);
		
	КонецЦикла;
	
	Если Параметры.Свойство("ПараметрыЛогированияЗапросовИСМП") Тогда
		
		ДанныеЛогирования = Новый Структура();
		ДанныеЛогирования.Вставить("ДанныеИдентификаторов", ДанныеИдентификаторов);
		
		ЛогированиеЗапросовИСМП.УстановитьПараметрыЛогированияЗапросов(Параметры.ПараметрыЛогированияЗапросовИСМП);
		ЛогированиеЗапросовИС.НастроитьПараметрыЛогированияВФоновомЗадании(Параметры.ПараметрыЛогированияЗапросовИСМП);
		ЛогированиеЗапросовИСМП.УстановитьПараметрыЛогированияЗапросов(Параметры.ПараметрыЛогированияЗапросовИСМП);
		
		ЛогированиеЗапросовИСМП.ЗаполнитьВозвращаемыеДанныеФоновогоЗадания(ДанныеЛогирования);
		
	КонецЕсли;
	
	ДлительныеОперации.СообщитьПрогресс(КоличествоДанных, ТекстПрогресса);
	ПоместитьВоВременноеХранилище(ДанныеИдентификаторов, АдресРезультата);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОбработкаРезультатаЕмкостьУпаковкиПоGTIN(ИсходныеДанные)
	
	Результат     = Новый Соответствие();
	ОписаниеЧисло = Новый ОписаниеТипов("Число");
	Для Каждого КлючИЗначение Из ИсходныеДанные Цикл
		
		GTIN                 = КлючИЗначение.Ключ;
		ДанныеОписанияТовара = КлючИЗначение.Значение;
		ЕмкостьУпаковки      = ОписаниеЧисло.ПривестиЗначение(ДанныеОписанияТовара.ЕмкостьУпаковки);
		Если Не ЗначениеЗаполнено(ЕмкостьУпаковки) Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.Вставить(GTIN, ЕмкостьУпаковки);
	
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОбработкаМестаОсуществленияДеятельности(ИсходныеДанные)
	
	ВозвращаемоеЗначение = Новый Массив();
	КешДобавленных       = Новый Соответствие();
	
	Для Каждого СтрокаДанных Из ИсходныеДанные Цикл
		
		Если КешДобавленных[СтрокаДанных.КодФИАС] <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрокаДанных = Новый Структура("КодФИАС, ДанныеАдреса, ПредставлениеАдреса", СтрокаДанных.КодФИАС);
		
		НоваяСтрокаДанных.ДанныеАдреса = РаботаСАдресами.АдресПоИдентификатору(СтрокаДанных.КодФИАС);
		
		Если НоваяСтрокаДанных.ДанныеАдреса <> Неопределено Тогда
			НоваяСтрокаДанных.ПредставлениеАдреса = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(
				НоваяСтрокаДанных.ДанныеАдреса);
		КонецЕсли;
		
		ВозвращаемоеЗначение.Добавить(НоваяСтрокаДанных);
		
		КешДобавленных[СтрокаДанных.КодФИАС] = НоваяСтрокаДанных;
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Процедура ЗаполнитьОрганизациюПараметровОбработкиПоКлючуСессии(ПараметрыОбработки)
	
	Если ЗначениеЗаполнено(ПараметрыОбработки.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗапроса  = ИнтерфейсИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии();
	ДанныеКлючаСессии = ИнтерфейсАвторизацииИСМПСлужебный.ПолучитьСохраненныеДанныеКлючаСессии(ПараметрыЗапроса.ИмяПараметраСеанса);
	ОрганизацииСИстекшимКлючем = Новый ТаблицаЗначений();
	ОрганизацииСИстекшимКлючем.Колонки.Добавить("Организация");
	ОрганизацииСИстекшимКлючем.Колонки.Добавить("ДействуетДо");
	
	Если ДанныеКлючаСессии <> Неопределено Тогда
		Для Каждого КлючИЗначение Из ДанныеКлючаСессии Цикл
			Организация          = КлючИЗначение.Ключ;
			ПараметрыКлючаСессии = КлючИЗначение.Значение;
			Если ПараметрыКлючаСессии.ДействуетДо > ТекущаяДатаСеанса() Тогда
				ПараметрыОбработки.Организация = Организация;
				Возврат;
			Иначе
				НоваяСтрока = ОрганизацииСИстекшимКлючем.Добавить();
				НоваяСтрока.Организация = Организация;
				НоваяСтрока.ДействуетДо = ПараметрыКлючаСессии.ДействуетДо;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	СертификатыДляПодписания = ИнтерфейсАвторизацииИСМПСлужебный.СертификатыДляПодписанияНаСервере();
	
	Если СертификатыДляПодписания <> Неопределено
		И СертификатыДляПодписания.Сертификаты.Количество() Тогда
		ПараметрыОбработки.Организация = СертификатыДляПодписания.Сертификаты[0].Организация;
		Возврат;
	КонецЕсли;
	
	Если ОрганизацииСИстекшимКлючем.Количество() Тогда
		ОрганизацииСИстекшимКлючем.Сортировать("ДействуетДо убыв");
		ПараметрыОбработки.Организация = ОрганизацииСИстекшимКлючем[0].Организация;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

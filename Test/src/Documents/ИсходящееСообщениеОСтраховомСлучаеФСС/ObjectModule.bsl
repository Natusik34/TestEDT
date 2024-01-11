#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	ИсправленныйДокумент = ОбъектКопирования.Ссылка;
	ОтключитьПроверкиПроведения = Ложь;
	ХранилищеXML                = Неопределено;
	ДатаОтправки                = '00010101';
	ИдентификаторСообщения      = "";
КонецПроцедуры

Процедура ОбработкаЗаполнения(Основание, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(Основание) = Тип("Структура") Тогда
		Если Основание.Свойство("Действие")
			И Основание.Действие = "Исправить"
			И ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыРасширеннаяПодсистемы.ИсправленияДокументов") Тогда
			МодульИсправлениеДокументовЗарплатаКадры = ОбщегоНазначения.ОбщийМодуль("ИсправлениеДокументовЗарплатаКадры");
			МодульИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(
				ЭтотОбъект,
				Основание.Ссылка,
				,
				,
				Основание);
		Иначе
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Основание);
			Если Не ЗначениеЗаполнено(ДокументОснование) Тогда
				Основание = ОбщегоНазначенияБЗК.ЗначениеСвойства(Основание, "Основание");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Основание) = Тип("СправочникСсылка.Сотрудники") Тогда
		Сотрудник = Основание;
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ВходящийЗапросФССДляРасчетаПособия")
		И ЗначениеЗаполнено(Основание) Тогда
		ДокументОснование = Основание;
		ОтветНаЗапрос = ПоследнийОтветНаЗапрос(Основание);
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ОтветНаЗапросФССДляРасчетаПособия")
		И ЗначениеЗаполнено(Основание) Тогда
		ДокументОснование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "ВходящийЗапрос");
		ОтветНаЗапрос = Основание;
	ИначеЕсли Метаданные().Реквизиты.ДокументОснование.Тип.СодержитТип(ТипЗнч(Основание))
		И ЗначениеЗаполнено(Основание) Тогда
		ДокументОснование = Основание;
		ОтветНаЗапрос = ПоследнийОтветНаЗапрос(Основание);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОтветНаЗапрос) Тогда
		ПараметрыФиксации = Документы.ИсходящееСообщениеОСтраховомСлучаеФСС.ПараметрыФиксацииВторичныхДанных();
		ЗаполнитьДанныеИзОтветаНаЗапрос(ПараметрыФиксации, Ложь);
	КонецЕсли;
	
	ЗначенияДляЗаполнения = Новый Структура("Ответственный");
	ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗначенияДляЗаполнения);
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		КадровыеДанные = КадровыеДанныеСотрудника();
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, КадровыеДанные);
	КонецЕсли;
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		ПараметрыФиксации = Документы.ИсходящееСообщениеОСтраховомСлучаеФСС.ПараметрыФиксацииВторичныхДанных();
		ЗаполнитьДанныеИзОснования(ПараметрыФиксации, Ложь);
	КонецЕсли;
	
	ОбновитьВторичныеДанные();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ПроверяемыеРеквизиты.Очистить();
	
	СведенияОВидеПособия = СЭДОФСС.СведенияОВидеПособия(ВидПособия);
	Особенности = Документы.ИсходящееСообщениеОСтраховомСлучаеФСС.ОсобенностиВыгрузки(ЭтотОбъект);
	
	Если Перерасчет Тогда
		// Инициация перерасчета. Запрос сведений о записи реестра выплаты.
		СЭДОФСС.ПроверитьИдентификаторСтрокиРеестра(Отказ, ЭтотОбъект, "ИдентификаторСтрокиРеестра");
		
	ИначеЕсли СведенияОВидеПособия.ЭтоОтпускПоУходу Тогда
		// Отпуск по уходу за ребёнком по достижении им возраста полутора лет.
		ПроверитьСведенияОЗастрахованномЛице(Отказ, ПроверяемыеРеквизиты, СведенияОВидеПособия);
		ПроверитьИнформациюОРебенке(Отказ, ПроверяемыеРеквизиты);
		ПроверитьОснованияДляНазначенияОтпускаПоУходу(Отказ, ПроверяемыеРеквизиты);
		ПроверитьДатуРожденияРебенка(Отказ, ПроверяемыеРеквизиты);
		
	ИначеЕсли СведенияОВидеПособия.ЭтоПособиеПриРождении Тогда
		// Рождение ребёнка.
		ПроверитьСведенияОЗастрахованномЛице(Отказ, ПроверяемыеРеквизиты, СведенияОВидеПособия);
		ПроверитьИнформациюОРебенке(Отказ, ПроверяемыеРеквизиты);
		ПроверитьОснованияДляНазначенияПособияПриРождении(Отказ, ПроверяемыеРеквизиты, Особенности);
		
	ИначеЕсли СведенияОВидеПособия.ЭтоЛН Тогда
		// Данные о закрытии листка нетрудоспособности.
		ПроверитьСведенияОЗастрахованномЛице(Отказ, ПроверяемыеРеквизиты, СведенияОВидеПособия);
		ПроверитьСведенияОбЭЛН(Отказ);
		
	КонецЕсли;
	
	ПроверитьСведенияОСтрахователе(Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// Заполнение недостающих полей.
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаСоздания) Тогда
		ДатаСоздания = ТекущаяДата(); // АПК:143 Для фильтрации событий в журнале регистрации требуется дата сервера.
	КонецЕсли;
	
	// Заполнение текста XML.
	ЭтоПроведение = (РежимЗаписи = РежимЗаписиДокумента.Проведение
		Или (Проведен И РежимЗаписи = РежимЗаписиДокумента.Запись));
	Если ЭтоПроведение Тогда
		ТекстXML = Документы.ИсходящееСообщениеОСтраховомСлучаеФСС.ТекстXML(ЭтотОбъект);
	Иначе
		ТекстXML = "";
	КонецЕсли;
	ХранилищеXML = Новый ХранилищеЗначения(ТекстXML, Новый СжатиеДанных(9));
	
	// Чтение реквизитов "До записи" для проверки и подготовки сведений к процедуре ПриЗаписи.
	ЗначенияРеквизитовДоЗаписи = ЗначенияРеквизитовДоЗаписи();
	ДополнительныеСвойства.Вставить("ЗначенияРеквизитовДоЗаписи", ЗначенияРеквизитовДоЗаписи);
	
	// Проверка отсутствия критичных изменений в отправленном документе.
	Если ЗначениеЗаполнено(ИдентификаторСообщения)
		И ЗначениеЗаполнено(ЗначенияРеквизитовДоЗаписи.ФизическоеЛицо)
		И ЗначенияРеквизитовДоЗаписи.ФизическоеЛицо <> ФизическоеЛицо Тогда
		ВызватьИсключение НСтр("ru = 'Недопустимо изменять физическое лицо в отправленном документе.'");
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	РегистрыСведений.РегистрацииИсходящихСообщенийОСтраховыхСлучаяхФСС.ЗаполнитьПоДокументу(ЭтотОбъект);
	РегистрыСведений.СведенияОбЭЛН.ПриЗаписиИсходящегоСообщенияОСтраховомСлучае(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПередЗаписью

Функция ЗначенияРеквизитовДоЗаписи()
	ИменаРеквизитов = "Дата, НомерЛН, ГоловнаяОрганизация, ФизическоеЛицо, ПометкаУдаления, Проведен";
	ЭтоНовый = ЭтоНовый();
	Если ЭтоНовый Тогда
		Результат = ОбщегоНазначенияБЗК.ЗначенияСвойств(ЭтотОбъект, ИменаРеквизитов);
	Иначе
		Результат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, ИменаРеквизитов);
	КонецЕсли;
	Результат.Вставить("ЭтоНовый", ЭтоНовый);
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область ФиксацияВторичныхДанныхВДокументах

Функция ОбновитьВторичныеДанные(ПараметрыФиксации = Неопределено) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Модифицирован = Ложь;
	
	Если ОбъектЗафиксирован() Тогда
		Возврат Модифицирован;
	КонецЕсли;
	
	Если ПараметрыФиксации = Неопределено Тогда
		ПараметрыФиксации = Документы.ИсходящееСообщениеОСтраховомСлучаеФСС.ПараметрыФиксацииВторичныхДанных();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если ЗаполнитьВерсиюСпецификации(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьДанныеИзОтветаНаЗапрос(ПараметрыФиксации, Истина) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьДанныеИзОснования(ПараметрыФиксации, Истина) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьДанныеОрганизации(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьКадровыеДанныеСотрудника(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ЗаполнитьКадровыеДанныеРебенка(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Возврат Модифицирован;
КонецФункции

Функция ОбъектЗафиксирован() Экспорт
	Возврат Документы.ИсходящееСообщениеОСтраховомСлучаеФСС.ОбъектЗафиксирован(ЭтотОбъект);
КонецФункции

Функция ЗаполнитьВерсиюСпецификации(ПараметрыФиксации)
	Реквизиты = Новый Структура("ВерсияСпецификации", "");
	Если СЭДОФСС.ТекущаяДатаФонда() >= СЭДОФСС.ДатаПереходаНаВерсиюПроактива_2_34() Тогда
		Реквизиты.ВерсияСпецификации = "2.34";
	КонецЕсли;
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьДанныеИзОснования(ПараметрыФиксации, УчитыватьФиксацию) Экспорт
	Реквизиты = ДанныеОснования(ПараметрыФиксации);
	Если Реквизиты = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	Если УчитыватьФиксацию Тогда
		Если ЗначениеЗаполнено(Реквизиты.Ребенок)
			Или ФиксацияВторичныхДанныхВДокументах.РеквизитШапкиЗафиксирован(ЭтотОбъект, "Ребенок") Тогда
			Реквизиты = КоллекцииБЗК.СкопироватьСтруктуру(Реквизиты);
			КоллекцииБЗК.УдалитьКлючиСтруктуры(Реквизиты, ИменаРеквизитовЗаполняемыхИзРебенка(ПараметрыФиксации));
		КонецЕсли;
		Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
	Иначе
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Реквизиты);
		ФиксацияВторичныхДанныхВДокументах.ОтменитьФиксациюРеквизитовШапки(ЭтотОбъект, Реквизиты);
		Возврат Истина;
	КонецЕсли;
КонецФункции

Функция ДанныеОснования(ПараметрыФиксации)
	Если Не ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	КлючКэша = "ДанныеПервичногоДокумента";
	ЗначениеИзКэша = ОбщегоНазначенияБЗК.ЗначениеСвойства(ДополнительныеСвойства, КлючКэша);
	Если ЗначениеИзКэша <> Неопределено Тогда
		Возврат ЗначениеИзКэша;
	КонецЕсли;
	
	Реквизиты = ФиксацияВторичныхДанныхВДокументахКлиентСервер.СтруктураПолейПоОснованиюЗаполнения(
		ПараметрыФиксации,
		"ДокументОснование, Ребенок");
	Реквизиты.Вставить("Организация");
	Реквизиты.Вставить("Сотрудник");
	Реквизиты.Вставить("ФизическоеЛицо");
	Реквизиты.Вставить("ВидПособия");
	Реквизиты.Вставить("Ребенок");
	Реквизиты.Вставить("ДатаНачалаСобытия");
	Реквизиты.Вставить("ИдентификаторСтрокиОснования"); // Обратная совместимость.
	Реквизиты.Вставить("ИдентификаторСтрокиРеестра");
	ДополнительныеСвойства.Вставить(КлючКэша, Реквизиты);
	
	МенеджерОснования = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ДокументОснование);
	МенеджерОснования.ЗаполнитьИсходящееСообщениеОСтраховомСлучаеФСС(ДокументОснование, ЭтотОбъект, Реквизиты);
	
	Реквизиты.Удалить("ИдентификаторСтрокиОснования");
	Если Не ЗначениеЗаполнено(Реквизиты.ИдентификаторСтрокиРеестра) Тогда
		Реквизиты.Удалить("ИдентификаторСтрокиРеестра");
	КонецЕсли;
	
	Если ВидПособия <> Реквизиты.ВидПособия Тогда
		Если Не ЗначениеЗаполнено(Реквизиты.ВидПособия) Тогда
			Реквизиты.Удалить("ВидПособия");
		ИначеЕсли (Реквизиты.ВидПособия = Перечисления.ПособияНазначаемыеФСС.ПособиеПоБеременностиИРодам
				Или Реквизиты.ВидПособия = Перечисления.ПособияНазначаемыеФСС.ПособиеПоБеременностиИРодамВставшимНаУчетВРанниеСроки
				Или Реквизиты.ВидПособия = Перечисления.ПособияНазначаемыеФСС.ЕдиновременноеПособиеПриРожденииРебенка)
			И (ВидПособия = Перечисления.ПособияНазначаемыеФСС.ПособиеПоБеременностиИРодам
				Или ВидПособия = Перечисления.ПособияНазначаемыеФСС.ПособиеПоБеременностиИРодамВставшимНаУчетВРанниеСроки
				Или ВидПособия = Перечисления.ПособияНазначаемыеФСС.ЕдиновременноеПособиеПриРожденииРебенка) Тогда
			Реквизиты.Удалить("ВидПособия");
		КонецЕсли;
	КонецЕсли;
	
	Возврат Реквизиты;
КонецФункции

Функция ЗаполнитьДанныеОрганизации(ПараметрыФиксации)
	// Головная организация заполняется безусловно, т.к. определяет права.
	ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Организация);
	
	Реквизиты = Новый Структура("Страхователь, НомерСтрахователяФСС, КодПодчиненностиФСС");
	Если ФиксацияВторичныхДанныхВДокументах.РеквизитыШапкиЗафиксированы(ЭтотОбъект, Реквизиты) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ИменаПолей = "НомерСтрахователяФСС, КодПодчиненностиФСС";
		Сведения = СЭДОФСС.СведенияОСтрахователе(Организация, ИменаПолей, Дата);
		Реквизиты.Страхователь         = Сведения.Страхователь;
		Реквизиты.НомерСтрахователяФСС = Сведения.НомерСтрахователяФСС;
		Реквизиты.КодПодчиненностиФСС  = Сведения.КодПодчиненностиФСС;
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ЗаполнитьКадровыеДанныеСотрудника(ПараметрыФиксации)
	Реквизиты = Новый Структура(
		"СотрудникФамилия,
		|СотрудникИмя,
		|СотрудникОтчество,
		|СотрудникДатаРождения,
		|СотрудникКатегория,
		|СотрудникСНИЛС");
	
	КадровыеДанные = КадровыеДанныеСотрудника();
	Если КадровыеДанные <> Неопределено Тогда
		РеквизитыФизическоеЛицо         = КадровыеДанные.ФизическоеЛицо;
		Реквизиты.СотрудникФамилия      = КадровыеДанные.Фамилия;
		Реквизиты.СотрудникИмя          = КадровыеДанные.Имя;
		Реквизиты.СотрудникОтчество     = КадровыеДанные.Отчество;
		Реквизиты.СотрудникДатаРождения = КадровыеДанные.ДатаРождения;
		Реквизиты.СотрудникСНИЛС        = КадровыеДанные.СтраховойНомерПФР;
	Иначе
		РеквизитыФизическоеЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
	КонецЕсли;
	
	Реквизиты.СотрудникКатегория = "INSURED"; // См. СЭДОФСС.СписокВыбораКатегорийЗастрахованныхЛиц.
	
	ЕстьИзменения = Ложь;
	Если ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации) Тогда
		ЕстьИзменения = Истина;
	КонецЕсли;
	Если ФизическоеЛицо <> РеквизитыФизическоеЛицо Тогда
		ФизическоеЛицо = РеквизитыФизическоеЛицо; // ФизическоеЛицо заполняется безусловно, т.к. определяет права.
		ЕстьИзменения = Истина;
	КонецЕсли;
	
	Возврат ЕстьИзменения;
КонецФункции

Функция КадровыеДанныеСотрудника()
	КадровыеДанныеСотрудника = ОбщегоНазначенияБЗК.ЗначениеСвойства(ДополнительныеСвойства, "КадровыеДанные");
	Если КадровыеДанныеСотрудника = Неопределено Тогда
		Если Не ЗначениеЗаполнено(Сотрудник) Тогда
			Возврат Неопределено;
		КонецЕсли;
		ИменаПолей = Документы.ИсходящееСообщениеОСтраховомСлучаеФСС.ИменаПолейТребуемыхКадровыхДанных();
		КадровыеДанныеСотрудника = КадровыйУчет.КадровыеДанныеСотрудника(Истина, Сотрудник, ИменаПолей, Дата);
		Если КадровыеДанныеСотрудника = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	Если ТипЗнч(КадровыеДанныеСотрудника) = Тип("Структура") Тогда
		Возврат КадровыеДанныеСотрудника;
	КонецЕсли;
	ИменаПолей = Документы.ИсходящееСообщениеОСтраховомСлучаеФСС.ИменаПолейТребуемыхКадровыхДанных();
	КадровыеДанные = Новый Структура(ИменаПолей);
	ЗаполнитьЗначенияСвойств(КадровыеДанные, КадровыеДанныеСотрудника);
	ДополнительныеСвойства.Вставить("КадровыеДанные", КадровыеДанные);
	Возврат КадровыеДанные;
КонецФункции

Функция ЗаполнитьКадровыеДанныеРебенка(ПараметрыФиксации)
	Реквизиты = Новый Структура(ИменаРеквизитовЗаполняемыхИзРебенка(ПараметрыФиксации));
	
	Если ЗначениеЗаполнено(Ребенок) Тогда
		КадровыеДанныеРебенка = СЭДОФСС.КадровыеДанныеРодственника(Ребенок, Истина);
		Реквизиты.РебенокФамилия      = КадровыеДанныеРебенка.Фамилия;
		Реквизиты.РебенокИмя          = КадровыеДанныеРебенка.Имя;
		Реквизиты.РебенокОтчество     = КадровыеДанныеРебенка.Отчество;
		Реквизиты.РебенокДатаРождения = КадровыеДанныеРебенка.ДатаРождения;
		Реквизиты.РебенокСНИЛС        = КадровыеДанныеРебенка.СНИЛС;
		Реквизиты.РебенокКодСвязи     = КадровыеДанныеРебенка.КодСвязи;
		Реквизиты.РебенокПол          = КадровыеДанныеРебенка.Пол;
	ИначеЕсли ЗначениеЗаполнено(ДокументОснование) Или ЗначениеЗаполнено(ОтветНаЗапрос) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(Реквизиты, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ИменаРеквизитовЗаполняемыхИзРебенка(ПараметрыФиксации)
	ИменаПолей = ФиксацияВторичныхДанныхВДокументахКлиентСервер.ИменаПолейПоОснованиямЗаполнения(ПараметрыФиксации);
	Возврат СтрСоединить(ИменаПолей.Ребенок, ", ");
КонецФункции

Функция ЗаполнитьДанныеИзОтветаНаЗапрос(ПараметрыФиксации, УчитыватьФиксацию)
	Если Не ЗначениеЗаполнено(ОтветНаЗапрос) Тогда
		Возврат Ложь;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(РегистрацияОтвета.Зарегистрирован, ЛОЖЬ)
	|		И РегистрацияОтвета.РегистрацияНомерРеестра <> """" КАК Перерасчет,
	|	Ответ.Сотрудник КАК Сотрудник,
	|	Ответ.Организация КАК Организация,
	|	ЕСТЬNULL(РегистрацияОтвета.Зарегистрирован, ЛОЖЬ) КАК Зарегистрирован,
	|	ЕСТЬNULL(РегистрацияОтвета.РегистрацияНомерРеестра, """") КАК ИдентификаторСтрокиРеестра,
	|	Ответ.ВидПособия КАК ВидПособия,
	|	Ответ.ДатаНачалаСобытия КАК ДатаНачалаСобытия,
	|	Ответ.ПервичныйДокумент КАК ДокументОснование,
	|	Ответ.ИнойДокументОРожденииДатаВыдачи КАК ИнойДокументОРожденииДатаВыдачи,
	|	Ответ.ИнойДокументОРожденииНомер КАК ИнойДокументОРожденииНомер,
	|	Ответ.ИнойДокументОРожденииСерия КАК ИнойДокументОРожденииСерия,
	|	Ответ.ИнойДокументОРожденииСерияНомер КАК ИнойДокументОРожденииСерияНомер,
	|	Ответ.КодПодчиненностиФСС КАК КодПодчиненностиФСС,
	|	Ответ.НомерЛН КАК НомерЛН,
	|	Ответ.НомерСтрахователяФСС КАК НомерСтрахователяФСС,
	|	Ответ.ОтпускПоУходуДатаНачала КАК ОтпускПоУходуДатаНачала,
	|	Ответ.ОтпускПоУходуДатаОкончания КАК ОтпускПоУходуДатаОкончания,
	|	Ответ.ПризнаниеСлучаяСтраховым КАК ПризнаниеСлучаяСтраховым,
	|	Ответ.Ребенок КАК Ребенок,
	|	Ответ.РебенокДатаРождения КАК РебенокДатаРождения,
	|	Ответ.РебенокИмя КАК РебенокИмя,
	|	Ответ.РебенокКодСвязи КАК РебенокКодСвязи,
	|	Ответ.РебенокОтчество КАК РебенокОтчество,
	|	Ответ.РебенокПол КАК РебенокПол,
	|	Ответ.РебенокСНИЛС КАК РебенокСНИЛС,
	|	Ответ.РебенокФамилия КАК РебенокФамилия,
	|	Ответ.СвидетельствоОРожденииДатаВыдачи КАК СвидетельствоОРожденииДатаВыдачи,
	|	Ответ.СвидетельствоОРожденииНомер КАК СвидетельствоОРожденииНомер,
	|	Ответ.СвидетельствоОРожденииСерия КАК СвидетельствоОРожденииСерия,
	|	Ответ.СотрудникДатаРождения КАК СотрудникДатаРождения,
	|	Ответ.СотрудникИмя КАК СотрудникИмя,
	|	Ответ.СотрудникКатегория КАК СотрудникКатегория,
	|	Ответ.СотрудникОтчество КАК СотрудникОтчество,
	|	Ответ.СотрудникСНИЛС КАК СотрудникСНИЛС,
	|	Ответ.СотрудникФамилия КАК СотрудникФамилия,
	|	Ответ.СправкаОРожденииДатаВыдачи КАК СправкаОРожденииДатаВыдачи,
	|	Ответ.СправкаОРожденииНомер КАК СправкаОРожденииНомер,
	|	Ответ.СправкаОРожденииФорма КАК СправкаОРожденииФорма
	|ИЗ
	|	Документ.ОтветНаЗапросФССДляРасчетаПособия КАК Ответ
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РегистрацииОтветовНаЗапросыФССДляРасчетаПособий КАК РегистрацияОтвета
	|		ПО Ответ.Ссылка = РегистрацияОтвета.ИсходящийДокумент
	|ГДЕ
	|	Ответ.Ссылка = &ОтветНаЗапрос";
	Запрос.УстановитьПараметр("ОтветНаЗапрос", ОтветНаЗапрос);
	Таблица = Запрос.Выполнить().Выгрузить();
	Если Таблица.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	РеквизитыОтвета = ОбщегоНазначения.ТаблицаЗначенийВМассив(Таблица)[0];
	Если Не РеквизитыОтвета.Зарегистрирован Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РеквизитыОтвета.ИдентификаторСтрокиРеестра)
		И СтрНайти(РеквизитыОтвета.ИдентификаторСтрокиРеестра, ":") = 0 Тогда
		РеквизитыОтвета.ИдентификаторСтрокиРеестра = РеквизитыОтвета.ИдентификаторСтрокиРеестра + ":1";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		РеквизитыОснования = ДанныеОснования(ПараметрыФиксации);
		КоллекцииБЗК.УдалитьКлючиСтруктуры(РеквизитыОтвета, РеквизитыОснования);
	КонецЕсли;
	Если ЗначениеЗаполнено(ДокументОснование) Или ЗначениеЗаполнено(Ребенок) Тогда
		РеквизитыРебенка = Новый Структура(ИменаРеквизитовЗаполняемыхИзРебенка(ПараметрыФиксации));
		КоллекцииБЗК.УдалитьКлючиСтруктуры(РеквизитыОтвета, РеквизитыРебенка);
	КонецЕсли;
	
	Если УчитыватьФиксацию Тогда
		Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(РеквизитыОтвета, ЭтотОбъект, ПараметрыФиксации);
	Иначе
		Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапкиБезУчетаФиксации(ЭтотОбъект, РеквизитыОтвета);
	КонецЕсли;
КонецФункции

Функция ПоследнийОтветНаЗапрос(Основание)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Ответ.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ОтветНаЗапросФССДляРасчетаПособия КАК Ответ
	|ГДЕ
	|	Ответ.ВходящийЗапрос = &Основание
	|	И Ответ.Проведен = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ответ.ДатаОтправки УБЫВ,
	|	Ответ.Дата УБЫВ";
	Запрос.УстановитьПараметр("Основание", Основание);
	Если ТипЗнч(Основание) <> Тип("ДокументСсылка.ВходящийЗапросФССДляРасчетаПособия") Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,
			"Ответ.ВходящийЗапрос = &Основание",
			"Ответ.ПервичныйДокумент = &Основание");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

#КонецОбласти

#Область ОбработкаПроверкиЗаполнения

Процедура ПроверитьСведенияОбЭЛН(Отказ)
	ПроверкиБЗК.ПроверитьНомерЛН(Отказ, ЭтотОбъект, "НомерЛН");
КонецПроцедуры

Процедура ПроверитьСведенияОЗастрахованномЛице(Отказ, ПроверяемыеРеквизиты, СведенияОВидеПособия)
	
	ПроверкиБЗК.ПроверитьСНИЛС(Отказ, ЭтотОбъект, "СотрудникСНИЛС");
	
	Если СведенияОВидеПособия.ЭтоОтпускПоУходу Или СведенияОВидеПособия.ЭтоПособиеПриРождении Тогда
		ПроверяемыеРеквизиты.Добавить("СотрудникФамилия");
		ПроверяемыеРеквизиты.Добавить("СотрудникИмя");
		ПроверяемыеРеквизиты.Добавить("СотрудникДатаРождения");
		ПроверяемыеРеквизиты.Добавить("РебенокКодСвязи");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьИнформациюОРебенке(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("РебенокФамилия");
	ПроверяемыеРеквизиты.Добавить("РебенокИмя");
	ПроверяемыеРеквизиты.Добавить("РебенокДатаРождения");
	
	ПроверкиБЗК.ПроверитьСНИЛС(Отказ, ЭтотОбъект, "РебенокСНИЛС");
	
КонецПроцедуры

Процедура ПроверитьДатуРожденияРебенка(Отказ, ПроверяемыеРеквизиты)
	Если ЗначениеЗаполнено(РебенокДатаРождения)
		И ЗначениеЗаполнено(ОтпускПоУходуДатаНачала)
		И НачалоДня(РебенокДатаРождения) > ОтпускПоУходуДатаНачала Тогда
		Текст = НСтр("ru = 'Дата начала отпуска не может быть меньше даты рождения ребенка'");
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "РебенокДатаРождения");
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьОснованияДляНазначенияОтпускаПоУходу(Отказ, ПроверяемыеРеквизиты)
	
	ПроверкиБЗК.ПроверитьПериод(
		Отказ,
		ЭтотОбъект,
		"ОтпускПоУходуДатаНачала",
		"ОтпускПоУходуДатаОкончания",
		НСтр("ru = 'отпуска по уходу'"),
		Истина);
	
	ЕстьСвидетельствоОРождении = (
			ЗначениеЗаполнено(СвидетельствоОРожденииСерия)
		Или ЗначениеЗаполнено(СвидетельствоОРожденииНомер)
		Или ЗначениеЗаполнено(СвидетельствоОРожденииДатаВыдачи));
	ЕстьИнойДокументОРождении = (
			ЗначениеЗаполнено(ИнойДокументОРожденииДатаВыдачи)
		Или ЗначениеЗаполнено(ИнойДокументОРожденииНомер));
	
	// Свидетельство о рождении.
	Если ЕстьСвидетельствоОРождении Или Не ЕстьИнойДокументОРождении Тогда
		ПроверяемыеРеквизиты.Добавить("СвидетельствоОРожденииСерия");
		ПроверяемыеРеквизиты.Добавить("СвидетельствоОРожденииНомер");
		ПроверяемыеРеквизиты.Добавить("СвидетельствоОРожденииДатаВыдачи");
		ПроверяемыеРеквизиты.Добавить("СвидетельствоОРожденииКемВыдано");
		Если СтрДлина(СвидетельствоОРожденииКемВыдано) > 200 Тогда
			Текст = НСтр("ru = 'Длина поля ""Кем выдано"" свидетельства о рождении превышает 200 символов'");
			СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "СвидетельствоОРожденииКемВыдано");
		КонецЕсли;
	КонецЕсли;
	
	// Иной документ подтверждающий рождение ребенка.
	Если ЕстьИнойДокументОРождении Тогда
		ПроверяемыеРеквизиты.Добавить("ИнойДокументОРожденииНомер");
		ПроверяемыеРеквизиты.Добавить("ИнойДокументОРожденииДатаВыдачи");
		ПроверяемыеРеквизиты.Добавить("ИнойДокументОРожденииКемВыдан");
	КонецЕсли;
	
	// Актовая запись ЗАГС.
	Если ЗначениеЗаполнено(АктоваяЗаписьОРожденииНомер)
		Или ЗначениеЗаполнено(АктоваяЗаписьОРожденииДата) Тогда
		ПроверяемыеРеквизиты.Добавить("АктоваяЗаписьОРожденииНомер");
		ПроверяемыеРеквизиты.Добавить("АктоваяЗаписьОРожденииДата");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьОснованияДляНазначенияПособияПриРождении(Отказ, ПроверяемыеРеквизиты, Особенности)
	
	ЕстьСвидетельствоОРождении = (
			ЗначениеЗаполнено(СвидетельствоОРожденииСерия)
		Или ЗначениеЗаполнено(СвидетельствоОРожденииНомер)
		Или ЗначениеЗаполнено(СвидетельствоОРожденииДатаВыдачи));
	ЕстьСправкаОРождении = (
			ЗначениеЗаполнено(СправкаОРожденииФорма)
		Или ЗначениеЗаполнено(СправкаОРожденииНомер));
	ЕстьИнойДокумент = (
			ЗначениеЗаполнено(ИнойДокументОРожденииДатаВыдачи)
		Или ЗначениеЗаполнено(ИнойДокументОРожденииНомер));
	
	Если Особенности.Версия_2_34 Тогда
		ПроверитьСвидетельствоОРождении = Ложь;
		ПроверитьСправкуОРождении       = ЕстьСправкаОРождении Или Не ЕстьИнойДокумент;
		ПроверитьИнойДокументОРождении  = ЕстьИнойДокумент;
	Иначе
		ПроверитьСвидетельствоОРождении = ЕстьСвидетельствоОРождении Или (Не ЕстьСправкаОРождении И Не ЕстьИнойДокумент);
		ПроверитьСправкуОРождении       = ЕстьСправкаОРождении;
		ПроверитьИнойДокументОРождении  = ЕстьИнойДокумент;
	КонецЕсли;
	
	// Свидетельство о рождении.
	Если ПроверитьСвидетельствоОРождении Тогда
		ПроверяемыеРеквизиты.Добавить("СвидетельствоОРожденииСерия");
		ПроверяемыеРеквизиты.Добавить("СвидетельствоОРожденииНомер");
		ПроверяемыеРеквизиты.Добавить("СвидетельствоОРожденииДатаВыдачи");
		ПроверяемыеРеквизиты.Добавить("СвидетельствоОРожденииКемВыдано");
		Если СтрДлина(СвидетельствоОРожденииКемВыдано) > 200 Тогда
			Текст = НСтр("ru = 'Длина поля ""Кем выдано"" свидетельства о рождении превышает 200 символов'");
			СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, Текст, "СвидетельствоОРожденииКемВыдано");
		КонецЕсли;
	КонецЕсли;
	
	// Справка о рождении.
	Если ПроверитьСправкуОРождении Тогда
		ПроверяемыеРеквизиты.Добавить("СправкаОРожденииФорма");
		ПроверяемыеРеквизиты.Добавить("СправкаОРожденииНомер");
		ПроверяемыеРеквизиты.Добавить("СправкаОРожденииДатаВыдачи");
		ПроверяемыеРеквизиты.Добавить("СправкаОРожденииКемВыдана");
	КонецЕсли;
	
	// Иной документ подтверждающий рождение ребенка.
	Если ПроверитьИнойДокументОРождении Тогда
		ПроверяемыеРеквизиты.Добавить("ИнойДокументОРожденииНомер");
		ПроверяемыеРеквизиты.Добавить("ИнойДокументОРожденииДатаВыдачи");
		ПроверяемыеРеквизиты.Добавить("ИнойДокументОРожденииКемВыдан");
	КонецЕсли;
	
	// Актовая запись ЗАГС.
	Если ЗначениеЗаполнено(АктоваяЗаписьОРожденииНомер)
		Или ЗначениеЗаполнено(АктоваяЗаписьОРожденииДата) Тогда
		ПроверяемыеРеквизиты.Добавить("АктоваяЗаписьОРожденииНомер");
		ПроверяемыеРеквизиты.Добавить("АктоваяЗаписьОРожденииДата");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьСведенияОСтрахователе(Отказ, ПроверяемыеРеквизиты)
	ПроверкиБЗК.ПроверитьРегистрационныйНомерФСС(Отказ, ЭтотОбъект, "НомерСтрахователяФСС");
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
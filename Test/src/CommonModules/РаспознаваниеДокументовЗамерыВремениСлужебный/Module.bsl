#Область СлужебныеПроцедурыИФункции

Функция ДоступнаОтправкаЗамеровВремени() Экспорт 
	
	Если РегламентныеЗаданияСервер.РаботаСВнешнимиРесурсамиЗаблокирована() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПытатьсяПодключитьсяПриПроверке = Ложь;
	Если Не РаспознаваниеДокументов.ПодключеноКСервисуРаспознавания(ПытатьсяПодключитьсяПриПроверке) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПараметрыОтправки = РегистрыСведений.РаспознаваниеДокументовПоследнийОтправленныйЗамерВремени.ПолучитьПараметры();
	
	Если ПараметрыОтправки.НомерСеанса = НомерСеансаИнформационнойБазы() Тогда 
		
		// Если сеанс, выполнивший последнюю отправку сообщений телеметрии, это текущий сеанс,
		// то отправка в этом сеансе доступна.
		
		Возврат Истина;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Сеансы = ПолучитьСеансыИнформационнойБазы();
	УстановитьПривилегированныйРежим(Ложь);
	
	Для Каждого Сеанс Из Сеансы Цикл
		
		// Если сеанс, выполнивший последнюю отправку сообщений телеметрии, все еще активен,
		// то отправка выполняется в другом сеансе и в этом сеансе она не доступна.
		
		Если Сеанс.НомерСеанса = ПараметрыОтправки.НомерСеанса Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция ОтправитьЗамерыВремени(НомерСеанса) Экспорт
	
	// 1. Выбрать ЗамерыВремени по ключевым операциям по шаблону "РаспознаваниеДокументов.%"
	// 2. Сгруппировать по ИдентификаторРезультата результаты по.
	// 3. Отправить каждую группу в виде списка телеметрий на конкретному ИдентификаторРезультата.
	
	ЗамерыВремени = Новый Соответствие;
	// * Ключ - ИдентификаторРезультата
	// * Значение - Массив Из см. ОписаниеЗамераВремени
	
	ПараметрыОтправки = РегистрыСведений.РаспознаваниеДокументовПоследнийОтправленныйЗамерВремени.ПолучитьПараметры();
	
	Запрос = НовыйЗапросЗамеровВремениРаспознаванияДокументов(ПараметрыОтправки.ДатаПоследнего);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	ДатаПоследнего = Неопределено;
	
	Пока Выборка.Следующий() Цикл
		
		ДатаПоследнего = Выборка.ДатаЗаписи;
		
		ЗамерВремени = ОписаниеЗамераВремени();
		ЗаполнитьЗначенияСвойств(ЗамерВремени, Выборка);
		
		ЗамерВремени.Пользователь = РаспознаваниеДокументовСериализацияСлужебный.MD5(Выборка.Пользователь);
		
		Данные = Неопределено;
		Попытка
			Данные = РаспознаваниеДокументовСериализацияСлужебный.JsonLoad(Выборка.Комментарий);
		Исключение
			ЗаписьЖурналаРегистрации(
				РаспознаваниеДокументов.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
			);
		КонецПопытки;
		
		ДанныеПодходятДляПередачи = ТипЗнч(Данные) = Тип("Структура")
			И Данные.Свойство("Платф")
			И Данные.Свойство("КонфВер")
			И Данные.Свойство("Конф")
			И Данные.Свойство("Разд")
			И Данные.Свойство("ДопИнф")
			И ТипЗнч(Данные.ДопИнф) = Тип("Структура")
			И Данные.ДопИнф.Свойство("ИдентификаторРезультата")
			И ТипЗнч(Данные.Разд) = Тип("Массив")
			И Данные.Разд.Количество() > 0;
		
		Если ДанныеПодходятДляПередачи Тогда 
			
			Если Данные.Разд[0] <> РаботаВМоделиСервиса.ЗначениеРазделителяСеанса() Тогда
				Продолжить;
			КонецЕсли;
			
			ИдентификаторРезультата = Данные.ДопИнф.ИдентификаторРезультата;
			
			ЗамерВремени.ВерсияПлатформы = Данные.Платф;
			ЗамерВремени.ВерсияКонфигурации = Данные.КонфВер;
			ЗамерВремени.Конфигурация = Данные.Конф;
			ЗамерВремени.РазделительДанных = Данные.Разд;
			ЗамерВремени.Данные = Данные.ДопИнф;
			
		Иначе
			
			ИдентификаторРезультата = "broken-telemetry-event";
			
			ЗамерВремени.Данные = Выборка.Комментарий;
			
		КонецЕсли;
		
		Пакет = ЗамерыВремени.Получить(ИдентификаторРезультата);
		Если Пакет = Неопределено Тогда
			Пакет = Новый Массив;
			ЗамерыВремени.Вставить(ИдентификаторРезультата, Пакет);
		КонецЕсли;
		Пакет.Добавить(ЗамерВремени);
		
	КонецЦикла;
	
	Для Каждого ЗамерВремени Из ЗамерыВремени Цикл
		Попытка
			ДанныеЗамера = Новый Структура("telemetry_data", ЗамерВремени.Значение);
			Пакет = Новый Структура("telemetry", ДанныеЗамера);
			РаспознаваниеДокументовКоннекторСлужебный.ПередатьОбратнуюСвязь(ЗамерВремени.Ключ, Пакет);
		Исключение
			ЗаписьЖурналаРегистрации(
				РаспознаваниеДокументов.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
			);
		КонецПопытки;
	КонецЦикла;
	
	РегистрыСведений.РаспознаваниеДокументовПоследнийОтправленныйЗамерВремени.ЗаписатьПараметры(
		ДатаПоследнего,
		НомерСеанса
	);
	
	Возврат Неопределено;
	
КонецФункции

Функция НовыйЗапросЗамеровВремениРаспознаванияДокументов(ДатаПоследнего)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КлючевыеОперации.Ссылка КАК Ссылка,
		|	КлючевыеОперации.Имя КАК Имя
		|ПОМЕСТИТЬ КлючевыеОперации
		|ИЗ
		|	Справочник.КлючевыеОперации КАК КлючевыеОперации
		|ГДЕ
		|	КлючевыеОперации.Имя ПОДОБНО ""РаспознаваниеДокументов.%""
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 100
		|	ЗамерыВремени.ДатаНачалаЗамера КАК ДатаНачалаЗамера,
		|	ЗамерыВремени.НомерСеанса КАК НомерСеанса,
		|	ЗамерыВремени.ДатаЗаписиНачалоЧаса КАК ДатаЗаписиНачалоЧаса,
		|	ЗамерыВремени.ВремяВыполнения КАК ВремяВыполнения,
		|	ЗамерыВремени.Комментарий КАК Комментарий,
		|	ЗамерыВремени.ДатаЗаписи КАК ДатаЗаписи,
		|	ЗамерыВремени.ДатаОкончания КАК ДатаОкончания,
		|	ЗамерыВремени.Пользователь КАК Пользователь,
		|	ЗамерыВремени.ДатаЗаписиЛокальная КАК ДатаЗаписиЛокальная,
		|	КлючевыеОперации.Имя КАК КлючеваяОперация
		|ИЗ
		|	РегистрСведений.ЗамерыВремени КАК ЗамерыВремени
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ КлючевыеОперации КАК КлючевыеОперации
		|		ПО ЗамерыВремени.КлючеваяОперация = КлючевыеОперации.Ссылка
		|ГДЕ
		|	ЗамерыВремени.ДатаЗаписи > &ДатаПоследнего
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаЗаписи";
	
	Запрос.УстановитьПараметр("ДатаПоследнего", ДатаПоследнего);
	
	Возврат Запрос;
	
КонецФункции

Функция ОписаниеЗамераВремени()
	
	Результат = Новый Структура;
	Результат.Вставить("КлючеваяОперация");
	Результат.Вставить("ДатаНачалаЗамера");
	Результат.Вставить("НомерСеанса");
	Результат.Вставить("ДатаЗаписиНачалоЧаса");
	Результат.Вставить("ВремяВыполнения");
	Результат.Вставить("ДатаЗаписи");
	Результат.Вставить("ДатаОкончания");
	Результат.Вставить("Пользователь");
	Результат.Вставить("ДатаЗаписиЛокальная");
	Результат.Вставить("КлючеваяОперация");
	Результат.Вставить("ВерсияПлатформы");
	Результат.Вставить("ВерсияКонфигурации");
	Результат.Вставить("Конфигурация");
	Результат.Вставить("РазделительДанных");
	Результат.Вставить("Данные");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

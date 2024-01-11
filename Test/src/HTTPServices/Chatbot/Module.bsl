
#Область СлужебныйПрограммныйИнтерфейс

Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru='Chatbot'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция TelegramPost(Запрос)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаписьЖурналаРегистрации("Получены данные", УровеньЖурналаРегистрации.Информация,,,Запрос);
	
	ИмяСобытияДляЖурналаРегистрации = НСтр("ru='Входящее сообщение'", ОбщегоНазначения.КодОсновногоЯзыка());;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЧатботов") Тогда
		ОписаниеОшибки = НСтр("ru='Использование чатботов отключено в настройках'");
		
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации() + "." + ИмяСобытияДляЖурналаРегистрации,
			УровеньЖурналаРегистрации.Ошибка,,,
			ОписаниеОшибки);
			
		Возврат Новый HTTPСервисОтвет(500, ОписаниеОшибки);
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации("Текст запроса", УровеньЖурналаРегистрации.Информация,,,Запрос.ПолучитьТелоКакСтроку());	
	
	ТелоЗапроса = Запрос.ПолучитьТелоКакСтроку();
	Если ПустаяСтрока(ТелоЗапроса) Тогда
		Возврат Новый HTTPСервисОтвет(204, НСтр("ru = 'Пустой запрос.'"));
	КонецЕсли;
	
	Данные = РаскодироватьСтроку(ТелоЗапроса, СпособКодированияСтроки.КодировкаURL);
	
	ЗаписьЖурналаРегистрации("Получены данные", УровеньЖурналаРегистрации.Информация,,,Данные);	
	
	Попытка
		СтруктураДанные = ЧатботСервер.ЧтениеJSONВСтруктуру(Данные, Истина);
		
		ЗаписьЖурналаРегистрации("Данные обработаны", УровеньЖурналаРегистрации.Информация,,,СтруктураДанные.Количество());	
		
		структураОтвет = ЧатботСервер.ОбработатьВходящееСообщение(СтруктураДанные);
		
		ЗаписьЖурналаРегистрации("Ответ", УровеньЖурналаРегистрации.Информация,,,структураОтвет);	
		
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-Type", "application/json;charset=utf-8");
		Если ЗначениеЗаполнено(структураОтвет) Тогда
			Ответ.УстановитьТелоИзСтроки(ЧатботСервер.ЗаписьJSONВСтруктуру(структураОтвет), КодировкаТекста.UTF8);
		Иначе
			Ответ.УстановитьТелоИзСтроки("ok");
		КонецЕсли;
		
		Возврат Ответ;
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации() + "." + ИмяСобытияДляЖурналаРегистрации,
			УровеньЖурналаРегистрации.Ошибка,,,
			ОписаниеОшибки);
		
		Возврат Новый HTTPСервисОтвет(500, ОписаниеОшибки);
	КонецПопытки;
	
КонецФункции

Функция pingGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("User-Agent", "1C Enterprise 8");
	Ответ.УстановитьТелоИзСтроки("ok");
	Возврат Ответ;
КонецФункции

#КонецОбласти

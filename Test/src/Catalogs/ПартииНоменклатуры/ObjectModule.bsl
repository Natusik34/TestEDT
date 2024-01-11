#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ЭтоНовыйОбъект;

#КонецОбласти 	

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовыйОбъект = ЭтоНовый();
	
	Если ПометкаУдаления И Не Ссылка.ПометкаУдаления
		Тогда
		
		НаборЗаписей = РегистрыСведений.ПартииКонтрагентов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Номенклатура.Установить(Владелец);
		НаборЗаписей.Отбор.Статус.Установить(Ссылка.Статус);
		НаборЗаписей.Отбор.Контрагент.Установить(Ссылка.ВладелецПартии);
		НаборЗаписей.Отбор.Партия.Установить(Ссылка);
		
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество()
			Тогда
			Попытка
				НаборЗаписей.Очистить();
				НаборЗаписей.Записать();
				ТекстСообщения = НСтр("ru = 'Основная партия %ИмяПартии% помечена на удаление. Признак <основная партия> снят.'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяПартии%", Наименование);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Исключение
				ТекстСообщения = НСтр("ru = 'Не удалось снять признак <основная партия> для партии %ИмяПартии%.'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяПартии%", Наименование);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		Если Не ЭтоНовый() Тогда
			УстановленноеЗначениеПоУмолчаниюСУчетомИзменений = НоменклатураВДокументахСервер.ЗначенияПартийНоменклатурыПоУмолчанию(Владелец, Статус, ВладелецПартии);
			
			Если НоменклатураВДокументахСервер.ПартияУстановленаПоУмолчанию(Ссылка)
				И ((ЗначениеЗаполнено(УстановленноеЗначениеПоУмолчаниюСУчетомИзменений) И Не Ссылка = УстановленноеЗначениеПоУмолчаниюСУчетомИзменений)
				ИЛИ (Не Статус = Ссылка.Статус  ИЛИ Не ВладелецПартии = Ссылка.ВладелецПартии)) Тогда
				
				ОтменитьИспользованиеПартииКакОсновной(Ссылка, Отказ)
				
			ИначеЕсли Недействителен Тогда
				
				ОтменитьИспользованиеПартииКакОсновной(Ссылка, Отказ)
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовыйОбъект И Не Недействителен
		И (Владелец.ПроверятьЗаполнениеПартий Или Не Статус = Перечисления.СтатусыПартий.СобственныеЗапасы)
		Тогда
		ИспользоватьКакОсновную(Ссылка, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Производит запись в регистр сведений значение партии по умолчанию для номенклатуры
//
Процедура ИспользоватьКакОсновную(Партия, Отказ = Ложь)
	
	НаборЗаписей = РегистрыСведений.ПартииКонтрагентов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Номенклатура.Установить(Партия.Владелец);
	НаборЗаписей.Отбор.Статус.Установить(Партия.Статус);
	НаборЗаписей.Отбор.Контрагент.Установить(Партия.ВладелецПартии);
	
	НаборЗаписей.Прочитать();
	
	Если Не НаборЗаписей.Количество() И КоличествоПартий(Партия) = 1
		Тогда
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Номенклатура = Партия.Владелец;
		НоваяЗапись.Статус = Партия.Статус;
		НоваяЗапись.Партия = Партия;
		НоваяЗапись.Контрагент = Партия.ВладелецПартии;
		
		Попытка
			НаборЗаписей.Записать();
		Исключение
			ТекстСообщения = НСтр("ru = 'При записи партии произошла ошибка!
			|Дополнительное описание: %ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ОписаниеОшибки());
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			
			Отказ = Истина;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

// Удаляет запись из регистра сведений значение партии по умолчанию для номенклатуры
//
Процедура ОтменитьИспользованиеПартииКакОсновной(Партия, Отказ = Ложь)
	
	НаборЗаписей = РегистрыСведений.ПартииКонтрагентов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Номенклатура.Установить(Партия.Владелец);
	НаборЗаписей.Отбор.Статус.Установить(Партия.Статус);
	НаборЗаписей.Отбор.Контрагент.Установить(Партия.ВладелецПартии);
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		ТекстСообщения = НСтр("ru = 'При записи партии произошла ошибка!
		|Дополнительное описание: %ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ОписаниеОшибки());
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
		Отказ = Истина;
	КонецПопытки;
	
КонецПроцедуры

// Возвращает количество партий по владельцу в разрезе статусов и поставщиков
//
Функция КоличествоПартий(Партия)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Владелец", Партия.Владелец);
	Запрос.УстановитьПараметр("Статус", Партия.Статус);
	Запрос.УстановитьПараметр("ВладелецПартии", Партия.ВладелецПартии);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ПартииНоменклатуры.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ПартииНоменклатуры КАК ПартииНоменклатуры
	               |ГДЕ
	               |	ПартииНоменклатуры.Владелец = &Владелец
	               |	И ПартииНоменклатуры.ВладелецПартии = &ВладелецПартии
	               |	И ПартииНоменклатуры.Статус = &Статус";
	Результат = Запрос.Выполнить().Выбрать();
	
	Возврат Результат.Количество(); 
	
КонецФункции

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("ПодконтрольнаяПродукцияВЕТИС");
	СтруктураРеквизитов.Вставить("ИспользоватьПроизводителяВЕТИСПартии");
	СтруктураРеквизитов.Вставить("ИспользоватьЗаписьСкладскогоЖурналаВЕТИСПартии");
	СтруктураРеквизитов.Вставить("ИспользоватьИдентификаторПартииВЕТИСПартии");
	СтруктураРеквизитов.Вставить("ИспользоватьДатуПроизводстваПартии");
	СтруктураРеквизитов.Вставить("ИспользоватьСрокГодностиПартии");
	
	ПараметрыВЕТИС = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Владелец, СтруктураРеквизитов);
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПодконтрольныхТоваровВЕТИС") И ПараметрыВЕТИС.ПодконтрольнаяПродукцияВЕТИС Тогда
		
		Если Не ПараметрыВЕТИС.ИспользоватьСрокГодностиПартии Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ГоденДо");
		КонецЕсли;
		
		Если Не ПараметрыВЕТИС.ИспользоватьДатуПроизводстваПартии Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ДатаПроизводства");
		КонецЕсли;
		
		Если Не ПараметрыВЕТИС.ИспользоватьПроизводителяВЕТИСПартии Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ПроизводительВЕТИС");
		КонецЕсли;
		
		Если Не ПараметрыВЕТИС.ИспользоватьЗаписьСкладскогоЖурналаВЕТИСПартии Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ЗаписьСкладскогоЖурналаВЕТИС");
		КонецЕсли;
		
		Если Не ПараметрыВЕТИС.ИспользоватьИдентификаторПартииВЕТИСПартии Тогда
			МассивНепроверяемыхРеквизитов.Добавить("ИдентификаторПартииВЕТИС");
		КонецЕсли;
		
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("ГоденДо");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаПроизводства");
		МассивНепроверяемыхРеквизитов.Добавить("ПроизводительВЕТИС");
		МассивНепроверяемыхРеквизитов.Добавить("ЗаписьСкладскогоЖурналаВЕТИС");
		МассивНепроверяемыхРеквизитов.Добавить("ИдентификаторПартииВЕТИС");
		
	КонецЕсли;
	
	Если Статус = Перечисления.СтатусыПартий.ТоварыНаКомиссии
		И Константы.ЗапретКомиссионныхПартийБезВладельца.Получить()
		И НЕ ЗначениеЗаполнено(ВладелецПартии) Тогда
		ПроверяемыеРеквизиты.Добавить("ВладелецПартии");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти 

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
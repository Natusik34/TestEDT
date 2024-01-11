#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция определяет необходимость расчета статуса поступления по уведомлению.
//
// Параметры:
// 	Статус - статус уведомления
//
// Возвращаемое значение:
//	Булево - статус заявки требует расчета поступления по уведомлению.
//
Функция СтатусТребуетРасчетаПоступления(Статус) Экспорт
	
	Если Статус = Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.ОбрабатываетсяПоступление
		Или Статус = Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Получено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Функция возвращает структуру значений по умолчанию для уведомления для движений.
//
// Возвращаемое значение:
//	Структура - значения по умолчанию.
//
Функция ЗначенияПоУмолчанию() Экспорт
	
	СтруктрураЗначенияПоУмолчанию = Новый Структура;
	
	СтруктрураЗначенияПоУмолчанию.Вставить("Документ",           Неопределено);
	
	СтруктрураЗначенияПоУмолчанию.Вставить("Статус",             Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Получено);
	СтруктрураЗначенияПоУмолчанию.Вставить("ДальнейшееДействие", Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПустаяСсылка());
	
	СтруктрураЗначенияПоУмолчанию.Вставить("ПоступлениеТоваров",           Неопределено);
	СтруктрураЗначенияПоУмолчанию.Вставить("КоличествоПоступленийТоваров", 0);
	СтруктрураЗначенияПоУмолчанию.Вставить("СтатусПоступления",            Перечисления.СтатусыПоступленийГИСМ.ПустаяСсылка());
	
	СтруктрураЗначенияПоУмолчанию.Вставить("КПередачеПодтверждения",   Ложь);
	СтруктрураЗначенияПоУмолчанию.Вставить("ПроцентПодтвержденныхКиЗ", 0);
	
	Возврат СтруктрураЗначенияПоУмолчанию;
	
КонецФункции

// Осуществляет запись в регистр по переданным данным.
//
// Параметры:
// 	ДанныеЗаписи - данные для записи в регистр.
//
Процедура ВыполнитьЗаписьВРегистрПоДаннымСтруктура(ДанныеЗаписи) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ДанныеЗаписи);
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Удаляет запись из регистра по переданному документу.
//
// Параметры:
// 	Документ - документ, данные по которому необходимо удалить.
//
Процедура УдалитьЗаписьИзРегистра(Документ) Экспорт

	НаборЗаписей = РегистрыСведений.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	НаборЗаписей.Записать();

КонецПроцедуры

// Удаляет дальнейшее действие из регистра по переданным документам.
//
// Параметры:
//   Ссылки - Массив Из ДокументСсылка - документы, не требующие дальнейших действий
//
Процедура Архивировать(Ссылки) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылки", Ссылки);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется) КАК ДальнейшееДействие,
	|	СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Документ,
	|	СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.КПередачеПодтверждения,
	|	СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.КоличествоПоступленийТоваров,
	|	СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.ПоступлениеТоваров,
	|	СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.ПроцентПодтвержденныхКиЗ,
	|	СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Статус,
	|	СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.СтатусПоступления
	|ИЗ
	|	РегистрСведений.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ КАК
	|		СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ
	|ГДЕ
	|	СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Документ В (&Ссылки)
	|	И СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.ДальнейшееДействие <> ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется)";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Набор = РегистрыСведений.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.СоздатьНаборЗаписей();
		Набор.Отбор.Документ.Установить(Выборка.Документ);
		ЗаполнитьЗначенияСвойств(Набор.Добавить(), Выборка);
		УстановитьПривилегированныйРежим(Истина);
		Набор.Записать();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЦикла;
	
КонецПроцедуры

// Возвращает статус документа.
//
// Параметры:
// 	УведомлениеОПоступлении - документ, для которого необходимо обновить статус
// 	Статус - статус документа
// 	ДальнейшееДействие - дальнейшее действие по документу.
//
// Возвращаемое значение:
//	ПеречислениеСсылка.СтатусыПоступленийГИСМ - новый статус документа.
//
Функция ОбновитьСтатус(УведомлениеОПоступлении, Статус, ДальнейшееДействие) Экспорт
	
	НовыйСтатус             = Неопределено;
	НовоеДальнейшееДействие = Неопределено;
	
	НаборЗаписей = НаборЗаписей(УведомлениеОПоступлении);
	
	Для Каждого ЗаписьНабора Из НаборЗаписей Цикл
		Если ЗаписьНабора.Статус <> Статус Тогда
			ЗаписьНабора.Статус = Статус;
			НовыйСтатус = Статус;
		КонецЕсли;
		Если ЗаписьНабора.ДальнейшееДействие <> ДальнейшееДействие Тогда
			ЗаписьНабора.ДальнейшееДействие = ДальнейшееДействие;
			НовоеДальнейшееДействие = ДальнейшееДействие;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(НовыйСтатус)
		Или ЗначениеЗаполнено(НовоеДальнейшееДействие) Тогда
		НаборЗаписей.Записать();
	КонецЕсли;
	
	Возврат НовыйСтатус;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НаборЗаписей(Документ)
	
	НаборЗаписей = РегистрыСведений.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Документ, Истина);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗначенияПоУмолчанию());
		НоваяЗапись.Документ = Документ;
		
	КонецЕсли;
	
	Возврат НаборЗаписей;
	
КонецФункции

#КонецОбласти

#КонецЕсли
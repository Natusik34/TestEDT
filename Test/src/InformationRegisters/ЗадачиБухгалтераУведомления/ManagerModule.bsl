#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляем в набор записей по правилу новое уведомление, если добавление не нужно, возвращаем ЛОЖЬ
Функция ДобавитьЗапись(Организация, Уведомление, ЗаписьКалендаря, ПериодСобытия) Экспорт
	
	ЗаписьИзменена = Ложь; 
	
	Если ЗначениеЗаполнено(ЗаписьКалендаря) И ЗначениеЗаполнено(ПериодСобытия) Тогда
	
	ДанныеЗаполнения = НовыйСтруктураРегистра();
	СтруктураЗаписи = НовыйСтруктураРегистра();
	
	НаборЗаписей = РегистрыСведений.ЗадачиБухгалтераУведомления.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Уведомление.Установить(Уведомление);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() > 0 Тогда
	
		ЗаписьПравила = НаборЗаписей[0];
		
	Иначе
		
		ЗаписьПравила = НаборЗаписей.Добавить();
	
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(
		СтруктураЗаписи,
		ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(ЗаписьПравила, Метаданные.РегистрыСведений.ЗадачиБухгалтераУведомления));
	
	ДанныеЗаполнения.Вставить("Организация",         Организация);
	ДанныеЗаполнения.Вставить("Уведомление",         Уведомление);
	ДанныеЗаполнения.Вставить("ЗаписьКалендаря",             ЗаписьКалендаря);
	ДанныеЗаполнения.Вставить("ПериодСобытия",       ПериодСобытия);
	
	Если НЕ ОбщегоНазначения.ДанныеСовпадают(СтруктураЗаписи, ДанныеЗаполнения) Тогда
		
		ЗаполнитьЗначенияСвойств(ЗаписьПравила, ДанныеЗаполнения);
		
		НаборЗаписей.Записать();
		
		ЗаписьИзменена = Истина;
	
	КонецЕсли; 
	
	КонецЕсли;
	
	Возврат ЗаписьИзменена;
	
КонецФункции

// Удаляет из регистра запись по об исполнении задачи указанным документом.
//
// Параметры:
//  Организация         - СправочникСсылка.Организации - организация
//  Уведомление  - ДокументСсылка - документ, по которому удаляется запись
//                       (допустимые типы - см. тип значения измерения Уведомление)
//
Процедура УдалитьЗапись(Организация, Уведомление) Экспорт
	
	ВнешняяТранзакция = ТранзакцияАктивна();
	
	Если НЕ ВнешняяТранзакция Тогда
		НачатьТранзакцию();
	КонецЕсли;
	
	// Установим управляемые блокировки
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗадачиБухгалтераУведомления");
	ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
	ЭлементБлокировки.УстановитьЗначение("Уведомление", Уведомление);
	Блокировка.Заблокировать();
	
	НаборЗаписей = РегистрыСведений.ЗадачиБухгалтераУведомления.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	НаборЗаписей.Отбор.Уведомление.Установить(Уведомление);
	
	НаборЗаписей.Записать();
	
	Если НЕ ВнешняяТранзакция Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция НовыйСтруктураРегистра()

	Возврат Новый Структура("Организация, Уведомление, Правило, ПериодСобытия");

КонецФункции 

#КонецОбласти

#КонецЕсли
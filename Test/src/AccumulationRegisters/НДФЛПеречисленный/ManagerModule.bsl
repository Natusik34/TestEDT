
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область РегистрацияФизическихЛиц

// АПК:299-выкл: Особенности иерархии библиотек

Функция РеквизитГоловнаяОрганизация() Экспорт
	Возврат Метаданные.РегистрыНакопления.НДФЛПеречисленный.Измерения.Организация.Имя;
КонецФункции

Функция РеквизитФизическоеЛицо() Экспорт
	Возврат Метаданные.РегистрыНакопления.НДФЛПеречисленный.Измерения.ФизическоеЛицо.Имя;
КонецФункции

// АПК:299-вкл

#КонецОбласти

#КонецОбласти

#КонецЕсли

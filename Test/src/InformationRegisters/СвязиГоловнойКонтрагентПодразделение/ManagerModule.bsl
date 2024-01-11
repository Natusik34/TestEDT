#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Функция возвращает подразделения выбранного контрагента
//
// Параметры:
//  - Контрагент - СправочникСсылка.Контрагенты - выбранный контрагент
//
// Возвращаемое значение:
//   ТаблицаЗначений - подразделения контрагента
//
Функция ПодразделенияКонтрагента(Контрагент) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СвязиГоловнойКонтрагентПодразделение.Подразделение КАК Подразделение,
	|	СвязиГоловнойКонтрагентПодразделение.ГоловнойКонтрагент КАК ГоловнойКонтрагент,
	|	СвязиГоловнойКонтрагентПодразделение.ОсновныеСведения КАК ОсновныеСведения
	|ИЗ
	|	РегистрСведений.СвязиГоловнойКонтрагентПодразделение КАК СвязиГоловнойКонтрагентПодразделение
	|ГДЕ
	|	СвязиГоловнойКонтрагентПодразделение.ГоловнойКонтрагент = &Контрагент";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
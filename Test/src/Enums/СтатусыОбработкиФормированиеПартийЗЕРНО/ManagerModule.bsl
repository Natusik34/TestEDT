#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Массив статусов, в которых проведенный документ требует резервирования исходной партии.
// 
// Возвращаемое значение:
//  Массив из ПеречислениеСсылка.СтатусыОбработкиФормированиеПартийЗЕРНО -- Требует резервирования партии
Функция ТребуетРезервированияПартии() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(Черновик);
	Результат.Добавить(ФормированиеПартииКПередаче);
	Результат.Добавить(ФормированиеПартииОбрабатывается);
	Результат.Добавить(ФормированиеПартииОшибкаПередачи);
	Возврат Результат;
	
КонецФункции

// Массив статусов, в которых проведенный документ требует списания исходной партии.
// 
// Возвращаемое значение:
//  Массив Из ПеречислениеСсылка.СтатусыОбработкиФормированиеПартийЗЕРНО - Требует списания партии
Функция ТребуетСписанияПартии() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(ПартияСформирована);
	Результат.Добавить(ПартииСформированыЧастично);
	Результат.Добавить(АннулированиеПартииКПередаче);
	Результат.Добавить(АннулированиеПартииОбрабатывается);
	Результат.Добавить(АннулированиеПартииОшибкаПередачи);
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
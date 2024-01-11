
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Вызывается при работе в модели сервиса для получения сведений о предопределенных вариантах отчета.
//
// Возвращаемое значение:
//  Массив из Структура:
//    * Имя           - Строка - имя варианта отчета; например, "Основной";
//    * Представление - Строка - имя варианта отчета; например, НСтр("ru = 'Динамика изменений файлов'").
//
Функция ВариантыНастроек() Экспорт 
	
	Результат = Новый Массив;
	Результат.Добавить(Новый Структура("Имя, Представление", "ЧистыеАктивы", 
		НСтр("ru = 'Чистые активы'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "Активы", 
		НСтр("ru = 'Активы'")));
	Результат.Добавить(Новый Структура("Имя, Представление", "Пассивы", 
		НСтр("ru = 'Пассивы'")));
	Возврат Результат;
	
КонецФункции

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Ложь);
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЧистыеАктивы, "ЧистыеАктивы");
	Вариант.Описание = НСтр("ru = 'Отчет показывает реальную стоимость имеющегося имущества, за вычетом долгов.'");
	Вариант.Размещение.Вставить(ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы());
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЧистыеАктивы, "Активы");
	Вариант.Описание = НСтр("ru = 'Отчет показывает реальную стоимость активов.'");
	Вариант.Включен = Ложь;
	Вариант.Размещение.Очистить();
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ЧистыеАктивы, "Пассивы");
	Вариант.Описание = НСтр("ru = 'Отчет показывает реальную стоимость пассивов.'");
	Вариант.Включен = Ложь;
	Вариант.Размещение.Очистить();
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли
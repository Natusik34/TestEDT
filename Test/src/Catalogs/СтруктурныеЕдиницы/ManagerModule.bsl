#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

#Область ЗаполнениеОбъектов

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеВерсииИБ

// Определяет настройки начального заполнения элементов.
//
// Параметры:
//  Настройки - Структура - настройки заполнения
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт

	Настройки.ПриНачальномЗаполненииЭлемента = Ложь;

КонецПроцедуры

// Смотри также ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ОсновноеПодразделение";
	Элемент.Наименование = НСтр("ru='Основное подразделение'");
	Элемент.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Подразделение;
	Элемент.Организация = Справочники.Организации.ОсновнаяОрганизация;
	
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ОсновнойСклад";
	Элемент.Наименование = НСтр("ru='Основной склад'");
	Элемент.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Склад;
	Элемент.Организация = Справочники.Организации.ОсновнаяОрганизация;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

// Функция возвращает список имен «ключевых» реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ТипСтруктурнойЕдиницы");
	
	Возврат Результат;
	
КонецФункции // ПолучитьБлокируемыеРеквизитыОбъекта()

// Функция возвращает количество складов или подразделений
//
// Параметры:
//  ТипСтруктурнойЕдиницы	 - ПеречислениеСсылка.ТипСтруктурнойЕдиницы	 - склад или подразделение
//  ВключаяОсновное			 - булево	 - учитывать основной склад или подразделение
// 
// Возвращаемое значение:
//  число - количество структурных единиц заданного типа
//
Функция КоличествоСтруктурныхЕдиниц(ТипСтруктурнойЕдиницы, ВключаяОсновное = Истина) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТипСтруктурнойЕдиницы", ТипСтруктурнойЕдиницы);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(СтруктурныеЕдиницы.Ссылка) КАК Количество
		|ИЗ
		|	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
		|ГДЕ
		|	СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = &ТипСтруктурнойЕдиницы";
		
	Если Не ВключаяОсновное Тогда
		
		Запрос.Текст = Запрос.Текст + "
		|	И СтруктурныеЕдиницы.Ссылка <> &ОсновноеЗначение";
		
		Запрос.УстановитьПараметр("ОсновноеЗначение",
			?(ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.Подразделение,
			Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение,
			Справочники.СтруктурныеЕдиницы.ОсновнойСклад));
		
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат ?(Выборка.Количество = Null, 0, Выборка.Количество);
	
КонецФункции

Функция ПолучитьСпециальныйНалоговыйРежим(Организация, СтруктурнаяЕдиница, Дата = Неопределено) Экспорт
	
	ПрименяетсяЕНВД = РегистрыСведений.ПримененияЕНВД.ПрименяетсяЕНВД(Организация, СтруктурнаяЕдиница, ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	Если ПрименяетсяЕНВД Тогда
		СпециальныйНалоговыйРежим = Перечисления.СпециальныеНалоговыеРежимы.ЕНВД;
	Иначе
		СпециальныйНалоговыйРежим = Перечисления.СпециальныеНалоговыеРежимы.НеПрименяется;
	КонецЕсли;
	
	Возврат СпециальныйНалоговыйРежим;
	
КонецФункции

// Возвращает строку представления структурной единицы.
// 
// Параметры:
// 	СтруктурнаяЕдиницаПредставление - Строка - представление структурной единицы,
// 	ЯчейкаПредставление - Строка - представление ячейки.
// Возвращаемое значение:
// 	Строка - представление структурной единицы;
Функция Представление(СтруктурнаяЕдиницаПредставление, ЯчейкаПредставление = "") Экспорт

	Если ЗначениеЗаполнено(ЯчейкаПредставление) Тогда
		Возврат СтрШаблон("%1 (%2)", СокрЛП(СтруктурнаяЕдиницаПредставление), СокрЛП(ЯчейкаПредставление));
	КонецЕсли;
	
	Возврат СокрЛП(СтруктурнаяЕдиницаПредставление);
	
КонецФункции

// Функция - Возвращает основной склад пользователя
// 
// Возвращаемое значение:
//  СправочникСсылка.СтруктурныеЕдиницы - Основной склад
//
Функция ОсновнойСклад() Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("УчетПоНесколькимСкладам") Тогда
		Возврат Справочники.СтруктурныеЕдиницы.ОсновнойСклад;	
	КонецЕсли;
	
	ЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
		Пользователи.ТекущийПользователь(), "ОсновнойСклад");
	Результат = ?(ЗначениеЗаполнено(ЗначениеНастройки), ЗначениеНастройки, 
		Справочники.СтруктурныеЕдиницы.ОсновнойСклад);
	Возврат Результат;
	
КонецФункции

// Функция - Возвращает основное подразделение пользователя
// 
// Возвращаемое значение:
//  СправочникСсылка.СтруктурныеЕдиницы - Основное подразделение
//
Функция ОсновноеПодразделение() Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("УчетПоНесколькимПодразделениям") Тогда
		Возврат Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение;	
	КонецЕсли;
	
	ЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
		Пользователи.ТекущийПользователь(), "ОсновноеПодразделение");
	Результат = ?(ЗначениеЗаполнено(ЗначениеНастройки), ЗначениеНастройки, 
		Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение);
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не Параметры.Отбор.Свойство("Недействителен") Тогда
		Параметры.Отбор.Вставить("Недействителен", Ложь);
	КонецЕсли;
	
	ЗапретитьВыборСкладУправляющейСистемы = Не (Параметры.Свойство("ВидОперации") И Параметры.ВидОперации = Перечисления.ВидыОперацийПеремещениеЗапасов.Перемещение);
	
	Если ЗапретитьВыборСкладУправляющейСистемы Тогда
		Параметры.Отбор.Вставить("СкладУправляющейСистемы", Ложь);
	КонецЕсли;
	
	//Для документа "Производство" доступны только ордерные склады с типом "По складу в целом".
	Если Параметры.Свойство("ВидУчетаОрдерныхСкладов") 
		И Параметры.ВидУчетаОрдерныхСкладов = ПредопределенноеЗначение("Перечисление.ВидыУчетаОрдерныхСкладов.ПоСкладуВЦелом") Тогда

		МассивТиповУчета = Новый Массив;
		МассивТиповУчета.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУчетаОрдерныхСкладов.ПоСкладуВЦелом"));
		МассивТиповУчета.Добавить(ПредопределенноеЗначение("Перечисление.ВидыУчетаОрдерныхСкладов.ПустаяСсылка"));
		
		ФиксированныйМассив = Новый ФиксированныйМассив(МассивТиповУчета);
		
		Параметры.Отбор.Вставить("ВидУчетаОрдерныхСкладов", ФиксированныйМассив);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область КонтактнаяИнформацияУНФ

Процедура ЗаполнитьДанныеПанелиКонтактнаяИнформация(ВладелецКИ, ДанныеПанелиКонтактнойИнформации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Ссылка КАК Ссылка,
	|	КонтактнаяИнформация.Тип КАК Тип,
	|	КонтактнаяИнформация.Вид КАК Вид,
	|	КонтактнаяИнформация.Представление КАК Представление,
	|	КонтактнаяИнформация.ЗначенияПолей КАК ЗначенияПолей,
	|	КонтактнаяИнформация.Значение КАК Значение
	|ИЗ
	|	Справочник.СтруктурныеЕдиницы.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Ссылка = &ВладелецКИ";
	
	Запрос.УстановитьПараметр("ВладелецКИ", ВладелецКИ);
	ДанныеКИ = Запрос.Выполнить().Выбрать();
	
	Пока ДанныеКИ.Следующий() Цикл
		НоваяСтрока = Новый Структура;
		Комментарий = УправлениеКонтактнойИнформацией.КомментарийКонтактнойИнформации(ДанныеКИ.Значение);
		НоваяСтрока.Вставить("Отображение", Строка(ДанныеКИ.Вид) + ": " + ДанныеКИ.Представление + ?(ПустаяСтрока(Комментарий), "", ", " + Комментарий));
		НоваяСтрока.Вставить("ИндексПиктограммы", КонтактнаяИнформацияПанельУНФ.ИндексПиктограммыПоТипу(ДанныеКИ.Тип));
		НоваяСтрока.Вставить("ТипОтображаемыхДанных", "ЗначениеКИ");
		НоваяСтрока.Вставить("ВладелецКИ", ВладелецКИ);
		НоваяСтрока.Вставить("ПредставлениеКИ", ДанныеКИ.Представление);
		НоваяСтрока.Вставить("ТипКИ", ДанныеКИ.Тип);
		ДанныеПанелиКонтактнойИнформации.Добавить(НоваяСтрока);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("ТипСтруктурнойЕдиницы");
	Поля.Добавить("Родитель");
	Поля.Добавить("Наименование");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Если ТипЗнч(Данные) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Представление = Данные.Наименование;
	
	Если Данные.ТипСтруктурнойЕдиницы = Перечисления.ТипыСтруктурныхЕдиниц.МагазинГруппаСкладов Тогда
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Данные.Родитель) Тогда
		Возврат;
	КонецЕсли;
	
	Представление = СтрШаблон("%1 (%2)", Данные.Наименование, Данные.Родитель);
	
КонецПроцедуры

#КонецОбласти

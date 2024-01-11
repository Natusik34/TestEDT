

#Область ПрограммныйИнтерфейс

#Область ДанныеИнформационнойБазы

// Найти создать единицу измерения для КТРУ.
// 
// Параметры:
//  КодЕдиницыИзмерения - Строка - Код единицы измерения
//  НаименованиеЕдиницыИзмерения - Строка - Наименование единицы измерения
//  ЕдиницаИзмерения - СправочникСсылка.ЕдиницыИзмерения - Единица измерения
Процедура НайтиСоздатьЕдиницуИзмеренияКТРУ(КодЕдиницыИзмерения, НаименованиеЕдиницыИзмерения, ЕдиницаИзмерения) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСФормами

// Процедура, вызываемая из обработчика события формы ПриСозданииНаСервере.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
//  Отказ                - Булево - признак отказа от создания формы. Если установить
//                                  данному параметру значение Истина, то форма создана не будет.
//  СтандартнаяОбработка - Булево - в данный параметр передается признак выполнения стандартной (системной) обработки
//                                  события. Если установить данному параметру значение Ложь, 
//                                  стандартная обработка события производиться не будет.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Вызывается из обработчика ПриЗагрузкеДанныхИзНастроекНаСервере формы.
//
// Параметры:
//  Форма     - ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
//  Настройки - Соответствие - значения реквизитов формы.
//
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Форма, Настройки) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаКлассификаторов

// Переопределяет идентификатор классификатора в сервисе интернет поддержки.
//
// Параметры:
//  Идентификатор - Строка - идентификатор классификатора в сервисе интернет поддержки.
//
Процедура ИдентификаторКлассификатораВСервисеИнтернетПоддержки(Идентификатор) Экспорт
	
	
	
КонецПроцедуры

// Переопределяет необходимость загрузки и обновления всего классификатора без учета ранее загруженных данных.
//
// Параметры:
//  ЗагружатьПолностью - Булево - признак необходимости загрузки и обновления всего классификатора.
//                       Истина - весь классификатор загружается и обновляется без учета ранее загруженных данных.
//                       Ложь   - (по умолчанию) значения загружаются пользователем интерактивно,
//                                 обновляются только те значения, которые были загружены ранее.
//
Процедура ЗагружатьКлассификаторПолностью(ЗагружатьПолностью) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаДочернихКлассификаторов

// Процедура, вызываемая для конвертации исходные данные дочерних классификаторов текущего элемента КТРУ
// во внутренний формат, для дальнейшей записи в объект
// (см. ЗаполнитьОбъектДаннымиДочернихКлассификаторов).
//
// Параметры:
//  ИсходныеДанные - Структура - исходные данные дочерних классификаторов текущего элемента КТРУ.
//  ДанныеДочернихКлассификаторовЭлемента - Структура - результат конвертации исходных данных дочерних классификаторов текущего элемента КТРУ.
//
Процедура КонвертироватьДанныеДочернихКлассификаторовЭлемента(ИсходныеДанные, ДанныеДочернихКлассификаторовЭлемента) Экспорт
	
	
	
КонецПроцедуры

// Процедура, вызываемая для загрузки данных дочерних классификаторов из дополнительных источников данных,
// например, из сервиса интернет-поддержки.
// Полученные данные загружаются в процедуре ЗагрузитьДанныеДочернихКлассификаторовИзДополнительныхИсточников.
//
// Параметры:
//  ДанныеДочернихКлассификаторов - Структура - результат загрузки данных дочерних классификаторов из дополнительных источников данных.
//
Процедура ПолучитьДанныеДочернихКлассификаторовИзДополнительныхИсточников(ДанныеДочернихКлассификаторов) Экспорт
	
	
	
КонецПроцедуры

// Процедура, выполняющая загрузку данных дочерних классификаторов по данным КТРУ.
//
// Параметры:
//  ДанныеОсновногоКлассификатора - ТаблицаЗначений - данные загружаемых элементов классификатора КТРУ.
//  ДанныеДочернихКлассификаторов - Структура - результат, полученный из процедуры ПолучитьДанныеДочернихКлассификаторовИзДополнительныхИсточников.
//  РезультатЗагрузкиДочернихКлассификаторов - Структура со свойствами
//   * Создано  - Число - число созданных объектов дочерних классификаторов.
//   * Обновлен - Число - число обновленных объектов дочерних классификаторов.
//   * Ошибки   - Массив - массив ошибок.
//   * Объекты  - Соответствие - соответствие ссылок загруженных дочерних классификаторов идентификаторам, по которым в дальнейшем можно получить ссылку.
//
Процедура ЗагрузитьДанныеДочернихКлассификаторовИзДополнительныхИсточников(ДанныеОсновногоКлассификатора, ДанныеДочернихКлассификаторов, РезультатЗагрузкиДочернихКлассификаторов) Экспорт
	
	
	
КонецПроцедуры

// Заполняет объект КТРУ данными загруженных дочерних классификаторов.
//
// Параметры:
//  Объект - СправочникОбъект - объект справочника КТРУ, данные дочерних классификаторов которого необходимо дозаполнить.
//  ДанныеДочернихКлассификаторовЭлемента - Структура - результат конвертации исходных данных дочерних классификаторов текущего элемента КТРУ
//                                          (см. КонвертироватьДанныеДочернихКлассификаторовЭлемента).
//  ДанныеЗагруженныхДочернихКлассификаторов - Соответствие - данные всех загруженных дочерних классификаторов
//                                            РезультатЗагрузкиДочернихКлассификаторов.Объекты
//                                            (см. ЗагрузитьДанныеДочернихКлассификаторовИзДополнительныхИсточников).
//
Процедура ЗаполнитьОбъектДаннымиДочернихКлассификаторов(Объект, ДанныеДочернихКлассификаторовЭлемента, ДанныеЗагруженныхДочернихКлассификаторов) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

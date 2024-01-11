#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем Менеджер; // ОбработкаМенеджер.ФорматДоговорныйДокумент101
Перем ПространствоИмен; // Строка
Перем ДатаФормирования; // Дата
Перем ОшибкиЗаполнения; // Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область СтруктураДанных

// АПК:1243-выкл Отсутствует или неверно описана секция "Описание" в комментарии к экспортной процедуре (функции).

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.ИнформацияДокумента:
//   * ДополнительнаяИнформация - Неопределено - Значение по умолчанию
//                              - см. НоваяДополнительнаяИнформация
//   * КодЯзыкаДокумента        - Массив Из Строка
//   * ДополнительныеСведения   - Массив Из Строка
//   * Организация              - Неопределено - Значение по умолчанию
//                              - см. НоваяСторонаДоговора
//   * Контрагент               - Неопределено - Значение по умолчанию
//                              - см. НоваяСторонаДоговора
//   * СведенияОбОбщейСтоимости - Неопределено - Значение по умолчанию
//                              - см. НовыеСведенияОбОбщейСтоимости
//   * УсловияПоставки          - Неопределено - Значение по умолчанию
//                              - см. НовыеУсловияПоставки
//   * ПорядокРасчета           - Неопределено - Значение по умолчанию
//                              - см. НовыйПорядокРасчета
//   * СрокДействия             - Неопределено - Значение по умолчанию
//                              - см. НовыйСрокДействия
//
Функция ИнформацияДокумента() Экспорт
	
	Если Не ЗначениеЗаполнено(ИнформацияДокумента) Тогда
		Запись = ИнформацияДокумента.Добавить();
		Запись.КодЯзыкаДокумента = Новый Массив;
		Запись.ДополнительныеСведения = Новый Массив;
	КонецЕсли;
	
	Возврат ИнформацияДокумента[0];
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.ДополнительнаяИнформация:
//   * Поля - Массив Из см. НовоеДополнительноеПоле
//
Функция НоваяДополнительнаяИнформация() Экспорт
	
	Запись = ДополнительнаяИнформация.Добавить();
	Запись.Поля = Новый Массив;
	
	Возврат Запись;
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.ДополнительныеПоля
//
Функция НовоеДополнительноеПоле() Экспорт
	
	Возврат ДополнительныеПоля.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.СведенияОСторонахДоговора:
//   * ДополнительныеСведения    - Массив Из Строка
//   * ИдентификационныеСведения - Неопределено - Значение по умолчанию
//                               - см. НовыеИдентификационныеСведенияИП
//                               - см. НовыеИдентификационныеСведенияОрганизации
//                               - см. НовыеИдентификационныеСведенияИностранногоЛица
//                               - см. НовыеИдентификационныеСведенияФизЛица
//   * Адрес                     - Неопределено - Значение по умолчанию
//                               - см. НовыйАдресЗаПределамиРФ
//                               - см. НовыйАдресКЛАДР
//                               - см. НовыйАдресФИАС
//   * КонтактныеДанные          - Неопределено - Значение по умолчанию
//                               - см. НовыеКонтактныеДанные
//   * БанковскиеРеквизиты       - Неопределено - Значение по умолчанию
//                               - см. НовыеБанковскиеРеквизиты
//   * СведенияОПодписанте       - Массив Из см. НовыеСведенияОПодписанте
//
Функция НоваяСторонаДоговора() Экспорт
	
	Запись = СведенияОСторонахДоговора.Добавить();
	Запись.ДополнительныеСведения = Новый Массив;
	Запись.СведенияОПодписанте = Новый Массив;

	Возврат Запись;
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.БанковскиеРеквизиты
//
Функция НовыеБанковскиеРеквизиты() Экспорт

	Возврат БанковскиеРеквизиты.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.КонтактныеДанные
//
Функция НовыеКонтактныеДанные() Экспорт

	Возврат КонтактныеДанные.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.ИдентификационныеСведенияИП
//   * УдостоверениеЛичности - Неопределено - Значение по умолчанию
//                           - см. НовоеУдостоверениеЛичности
//   * ФИО                   - Неопределено - Значение по умолчанию
//                           - см. НовыеФИО
//
Функция НовыеИдентификационныеСведенияИП() Экспорт
	
	Возврат ИдентификационныеСведенияИП.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.ИдентификационныеСведенияОрганизации:
//   * КПП - Массив Из Строка
//
Функция НовыеИдентификационныеСведенияОрганизации() Экспорт

	Запись = ИдентификационныеСведенияОрганизации.Добавить();
	Запись.КПП = Новый Массив;
	
	Возврат Запись;
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.ИдентификационныеСведенияИностранногоЛица:
//   * УдостоверениеЛичностиИностранногоЛица - Неопределено - Значение по умолчанию
//                                           - см. НовоеУдостоверениеЛичностиИностранногоЛица
//
Функция НовыеИдентификационныеСведенияИностранногоЛица() Экспорт

	Возврат ИдентификационныеСведенияИностранногоЛица.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.ИдентификационныеСведенияФизЛица:
//   * УдостоверениеЛичности - Неопределено - Значение по умолчанию
//                           - см. НовоеУдостоверениеЛичности
//   * Адрес                 - Неопределено - Значение по умолчанию
//                           - см. НовыйАдресЗаПределамиРФ
//                           - см. НовыйАдресКЛАДР
//                           - см. НовыйАдресФИАС
//   * ФИО                   - Неопределено - Значение по умолчанию
//                           - см. НовыеФИО
//
Функция НовыеИдентификационныеСведенияФизЛица() Экспорт

	Возврат ИдентификационныеСведенияФизЛица.Добавить();
	
КонецФункции

// Параметры:
//  Фамилия  - см. Обработка.ФорматДоговорныйДокумент101.ФИО.Фамилия
//  Имя      - см. Обработка.ФорматДоговорныйДокумент101.ФИО.Имя
//  Отчество - см. Обработка.ФорматДоговорныйДокумент101.ФИО.Отчество
// 
// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.ФИО
//
Функция НовыеФИО(Фамилия = Неопределено, Имя = Неопределено, Отчество = Неопределено) Экспорт
	
	Запись = ФИО.Добавить();
	Запись.Фамилия = Фамилия;
	Запись.Имя = Имя;
	Запись.Отчество = Отчество;
	
	Возврат Запись;
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.УдостоверениеЛичности
//
Функция НовоеУдостоверениеЛичности() Экспорт

	Возврат УдостоверениеЛичности.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.УдостоверениеЛичностиИностранногоЛица
//
Функция НовоеУдостоверениеЛичностиИностранногоЛица() Экспорт

	Возврат УдостоверениеЛичностиИностранногоЛица.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.СведенияОбОбщейСтоимости:
//   * Предмет - Неопределено - Значение по умолчанию
//             - Массив Из см. НовыйПредмет
//
Функция НовыеСведенияОбОбщейСтоимости() Экспорт

	Возврат СведенияОбОбщейСтоимости.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.Предмет:
//   * ДополнительнаяИнформация - Неопределено - Значение по умолчанию
//                              - см. НоваяДополнительнаяИнформация
//
Функция НовыйПредмет() Экспорт

	Возврат Предмет.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.УсловияПоставки
//
Функция НовыеУсловияПоставки() Экспорт

	Возврат УсловияПоставки.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.ПорядокРасчетов
//
Функция НовыйПорядокРасчета() Экспорт

	Возврат ПорядокРасчетов.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.СрокДействия
//
Функция НовыйСрокДействия() Экспорт

	Возврат СрокДействия.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.СведенияОбИномДоговорномДокументе
//   * ДополнительныеСведенияСвязанногоДоговора - Массив Из Строка
//
Функция НовыеСведенияОбИномДоговорномДокументе() Экспорт

	Запись = СведенияОбИномДоговорномДокументе.Добавить();
	Запись.ДополнительныеСведенияСвязанногоДоговора = Новый Массив;

	Возврат Запись;
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.СведенияОПодписанте:
//   * ФИО                               - Неопределено - Значение по умолчанию
//                                       - см. НовыеФИО
//   * СведенияОбЭлектроннойДоверенности - Неопределено - Значение по умолчанию
//                                       - см. НовыеСведенияОбЭлектроннойДоверенности
//   * СведенияОБумажнойДоверенности     - Неопределено - Значение по умолчанию
//                                       - см. НовыеСведенияОБумажнойДоверенности
//
Функция НовыеСведенияОПодписанте() Экспорт

	Возврат СведенияОПодписанте.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.СведенияОБумажнойДоверенности:
//   * ФИО - Неопределено - Значение по умолчанию
//         - см. НовыеФИО
//
Функция НовыеСведенияОБумажнойДоверенности() Экспорт

	Возврат СведенияОБумажнойДоверенности.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.СведенияОбЭлектроннойДоверенности
//
Функция НовыеСведенияОбЭлектроннойДоверенности() Экспорт

	Возврат СведенияОбЭлектроннойДоверенности.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.АдресКЛАДР
//
Функция НовыйАдресКЛАДР() Экспорт

	Возврат АдресКЛАДР.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.АдресФИАС:
//   * МуниципальныйРайон            - см. НовыйРайонГородФИАС
//   * ГородскоеПоселение            - см. НовыйРайонГородФИАС
//   * НаселенныйПункт               - см. НовыеСведенияОВидеИНаименованииАдрЭлементаФИАС
//   * ЭлементПланировочнойСтруктуры - см. НовыеСведенияОТипеИНаименованииАдресногоЭлементаФИАС
//   * ЭлементУличноДорожнойСети     - см. НовыеСведенияОТипеИНаименованииАдресногоЭлементаФИАС
//   * ЗданиеСооружение              - Массив Из см. НовыеСведенияОНомереАдрЭлементаФИАС
//   * ПомещениеЗдания               - см. НовыеСведенияОНомереАдрЭлементаФИАС
//   * ПомещениеКвартиры             - см. НовыеСведенияОНомереАдрЭлементаФИАС
//
Функция НовыйАдресФИАС() Экспорт

	Запись = АдресФИАС.Добавить();
	Запись.МуниципальныйРайон = НовыйРайонГородФИАС();
	Запись.ГородскоеПоселение = НовыйРайонГородФИАС();
	Запись.НаселенныйПункт = НовыеСведенияОВидеИНаименованииАдрЭлементаФИАС();
	Запись.ЭлементПланировочнойСтруктуры = НовыеСведенияОТипеИНаименованииАдресногоЭлементаФИАС();
	Запись.ЭлементУличноДорожнойСети = НовыеСведенияОТипеИНаименованииАдресногоЭлементаФИАС();
	Запись.ЗданиеСооружение = Новый Массив;
	Запись.ПомещениеЗдания = НовыеСведенияОНомереАдрЭлементаФИАС();
	Запись.ПомещениеКвартиры = НовыеСведенияОНомереАдрЭлементаФИАС();
	
	Возврат Запись;
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.РайонГородФИАС
//
Функция НовыйРайонГородФИАС() Экспорт

	Возврат РайонГородФИАС.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.СведенияОВидеИНаименованииАдрЭлементаФИАС
//
Функция НовыеСведенияОВидеИНаименованииАдрЭлементаФИАС() Экспорт

	Возврат СведенияОВидеИНаименованииАдрЭлементаФИАС.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.СведенияОТипеИНаименованииАдрЭлементаФИАС
//
Функция НовыеСведенияОТипеИНаименованииАдресногоЭлементаФИАС() Экспорт

	Возврат СведенияОТипеИНаименованииАдрЭлементаФИАС.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.СведенияОНомереАдрЭлементаФИАС
//
Функция НовыеСведенияОНомереАдрЭлементаФИАС() Экспорт

	Возврат СведенияОНомереАдрЭлементаФИАС.Добавить();
	
КонецФункции

// Возвращаемое значение:
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.АдресЗаПределамиРФ
//
Функция НовыйАдресЗаПределамиРФ() Экспорт

	Возврат АдресЗаПределамиРФ.Добавить();
	
КонецФункции

// АПК:1243-вкл Отсутствует или неверно описана секция "Описание" в комментарии к экспортной процедуре (функции).

#КонецОбласти

#Область Перечисления

// см. Обработки.ФорматДоговорныйДокумент101.ПризнакиНаличияДопФайлов
//
Функция ПризнакиНаличияДопФайлов() Экспорт
	
	Возврат Менеджер.ПризнакиНаличияДопФайлов();
	
КонецФункции

// см. Обработки.ФорматДоговорныйДокумент101.ФункцииДокумента
//
Функция ФункцииДокумента() Экспорт
	
	Возврат Менеджер.ФункцииДокумента();
	
КонецФункции

// см. Обработки.ФорматДоговорныйДокумент101.ПризнакиПорядкаФормирования
//
Функция ПризнакиПорядкаФормирования() Экспорт
	
	Возврат Менеджер.ПризнакиПорядкаФормирования();
	
КонецФункции

// см. Обработки.ФорматДоговорныйДокумент101.ПризнакиНаличияПролонгации
//
Функция ПризнакиНаличияПролонгации() Экспорт
	
	Возврат Менеджер.ПризнакиНаличияПролонгации();
	
КонецФункции

// см. Обработки.ФорматДоговорныйДокумент101.ПризнакиПредметаДоговорногоДокумента
//
Функция ПризнакиПредметаДоговорногоДокумента() Экспорт
	
	Возврат Менеджер.ПризнакиПредметаДоговорногоДокумента();
	
КонецФункции

// см. Обработки.ФорматДоговорныйДокумент101.ВидыСделок
//
Функция ВидыСделок() Экспорт
	
	Возврат Менеджер.ВидыСделок();
	
КонецФункции

// см. Обработки.ФорматДоговорныйДокумент101.СтатусыПодписанта
//
Функция СтатусыПодписанта() Экспорт
	
	Возврат Менеджер.СтатусыПодписанта();
	
КонецФункции

// см. Обработки.ФорматДоговорныйДокумент101.ТипыПодписи
//
Функция ТипыПодписи() Экспорт
	
	Возврат Менеджер.ТипыПодписи();
	
КонецФункции

// см. Обработки.ФорматДоговорныйДокумент101.ВидыЭлементовМуниципальногоРайонаФИАС
//
Функция ВидыЭлементовМуниципальногоРайонаФИАС() Экспорт
	
	Возврат Менеджер.ВидыЭлементовМуниципальногоРайонаФИАС();

КонецФункции

// см. Обработки.ФорматДоговорныйДокумент101.ВидыЭлементовГородскихПоселенийФИАС
//
Функция ВидыЭлементовГородскихПоселенийФИАС() Экспорт
	
	Возврат Менеджер.ВидыЭлементовГородскихПоселенийФИАС();

КонецФункции

#КонецОбласти

#Область Автозаполнение

// Возвращает строку с автоматически заполненным адресом.
// 
// Параметры:
//  ВидКонтактнойИнформации    - СправочникСсылка.ВидыКонтактнойИнформации - отбор по виду контактной информации.
//                             - ПеречислениеСсылка.ТипыКонтактнойИнформации - отбор по типу контактной информации.
//  ОбъектКонтактнойИнформации - ОпределяемыйТип.ВладелецКонтактнойИнформации
//  ДатаАдреса                 - Дата, Неопределено - дата среза, на которую будет производиться поиск адреса
//  КонструкторЭД              - ОбработкаОбъект.ФорматДоговорныйДокумент101
//  
// Возвращаемое значение:
//  Неопределено - В случае, если адрес не найден.
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.АдресЗаПределамиРФ - Адрес в произвольном формате.
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.АдресКЛАДР - Адрес в формате КЛАДР.
//  ОбработкаТабличнаяЧастьСтрока.ФорматДоговорныйДокумент101.АдресФИАС - Адрес в формате ФИАС.
//
Функция ЗаполнитьАдресАвтоматически(ВидКонтактнойИнформации, ОбъектКонтактнойИнформации, ДатаАдреса,
		КонструкторЭД) Экспорт
	
	НовыйАдрес = Неопределено;
	
	Если Не ЗначениеЗаполнено(ОбъектКонтактнойИнформации) Тогда
		Возврат НовыйАдрес;
	КонецЕсли;
	
	КонтактнаяИнформация = КонтактнаяИнформацияАдреса(ВидКонтактнойИнформации, ОбъектКонтактнойИнформации, ДатаАдреса);
	
	Если ЗначениеЗаполнено(КонтактнаяИнформация) Тогда
		
		АдресЗначение = КонтактнаяИнформация[0].Значение;
		Адрес = РаботаСАдресами.СведенияОбАдресе(АдресЗначение, Новый Структура("КодыАдреса", Ложь));
		
		Если Адрес.КодСтраны = "643" Тогда // Россия
			
			АдресСоответствуетСтруктурированномуФорматуФНС = 
													ИнтеграцияЭДО.АдресСоответствуетСтруктурированномуФорматуФНС(Адрес);
			
			Если АдресСоответствуетСтруктурированномуФорматуФНС Тогда
				
				// Заполняем структурированный адрес.
				НовыйАдрес = КонструкторЭД.НовыйАдресКЛАДР();
				
				НовыйАдрес.Индекс          = Адрес.Индекс;
				КонструкторЭД.ОбработчикОшибок.УстановитьСвязь(НовыйАдрес, "Индекс", , , ОбъектКонтактнойИнформации);
				
				НовыйАдрес.КодРегиона      = Адрес.КодРегиона;
				КонструкторЭД.ОбработчикОшибок.УстановитьСвязь(НовыйАдрес, "КодРегиона", , ,
					ОбъектКонтактнойИнформации);
				
				ПредставлениеЭлемента      = ИнтеграцияЭДО.ПредставлениеАдресногоЭлемента(Адрес.Район,
					Адрес.РайонСокращение);
				НовыйАдрес.Район           = ПредставлениеЭлемента;
				
				ПредставлениеЭлемента      = ИнтеграцияЭДО.ПредставлениеАдресногоЭлемента(Адрес.Город,
					Адрес.ГородСокращение);
				НовыйАдрес.Город           = ПредставлениеЭлемента;
				
				ПредставлениеЭлемента      = ИнтеграцияЭДО.ПредставлениеАдресногоЭлемента(
					Адрес.НаселенныйПункт, Адрес.НаселенныйПунктСокращение);
				НовыйАдрес.НаселенныйПункт = ПредставлениеЭлемента;
				
				ПредставлениеЭлемента      = ИнтеграцияЭДО.ПредставлениеАдресногоЭлемента(Адрес.Улица,
					Адрес.УлицаСокращение);
				НовыйАдрес.Улица           = ПредставлениеЭлемента;
				
				ПредставлениеЭлемента      = ИнтеграцияЭДО.ПредставлениеАдресногоЭлемента(
					НРег(Адрес.Здание.ТипЗдания), "№", Адрес.Здание.Номер);
				НовыйАдрес.Дом             = ПредставлениеЭлемента;
				
				Если Адрес.Корпуса.Количество() Тогда
					ПредставлениеЭлемента  = ИнтеграцияЭДО.ПредставлениеАдресногоЭлемента(
						НРег(Адрес.Корпуса[0].ТипКорпуса), Адрес.Корпуса[0].Номер);
				Иначе
					ПредставлениеЭлемента  = "";
				КонецЕсли;
				НовыйАдрес.Корпус          = ПредставлениеЭлемента;

				Если Адрес.Помещения.Количество() Тогда
					ПредставлениеЭлемента  = ИнтеграцияЭДО.ПредставлениеАдресногоЭлемента(
						НРег(Адрес.Помещения[0].ТипПомещения), Адрес.Помещения[0].Номер);
				Иначе
					ПредставлениеЭлемента  = "";
				КонецЕсли;
				НовыйАдрес.Квартира        = ПредставлениеЭлемента;
				
			Иначе
				
				// Заполняем адрес в произвольной форме.
				НовыйАдрес = КонструкторЭД.НовыйАдресЗаПределамиРФ();
				
				НовыйАдрес.КодСтраны      = Адрес.КодСтраны;
				КонструкторЭД.ОбработчикОшибок.УстановитьСвязь(НовыйАдрес, "КодСтраны", , , ОбъектКонтактнойИнформации);
				
				Если Адрес.ТипАдреса = "Муниципальный" Тогда
					НовыйАдрес.Адрес      = Адрес.МуниципальноеПредставление;
				Иначе
					НовыйАдрес.Адрес      = Адрес.Представление;
				КонецЕсли;
				КонструкторЭД.ОбработчикОшибок.УстановитьСвязь(НовыйАдрес, "Адрес", , , ОбъектКонтактнойИнформации);
				
			КонецЕсли;
			
		Иначе
			
			// Заполняем адрес за пределами РФ.
			НовыйАдрес = КонструкторЭД.НовыйАдресЗаПределамиРФ();
			
			НовыйАдрес.КодСтраны      = Адрес.КодСтраны;
			КонструкторЭД.ОбработчикОшибок.УстановитьСвязь(НовыйАдрес, "КодСтраны", , , ОбъектКонтактнойИнформации);
			
			НовыйАдрес.Адрес      = Адрес.Представление;
			КонструкторЭД.ОбработчикОшибок.УстановитьСвязь(НовыйАдрес, "Адрес", , , ОбъектКонтактнойИнформации);
		
		КонецЕсли;

	КонецЕсли;

	Возврат НовыйАдрес;

КонецФункции

// Возвращает код страны из адреса.
// 
// Параметры:
//  ВидКонтактнойИнформации    - СправочникСсылка.ВидыКонтактнойИнформации - отбор по виду контактной информации.
//                             - ПеречислениеСсылка.ТипыКонтактнойИнформации - отбор по типу контактной информации.
//  ОбъектКонтактнойИнформации - ОпределяемыйТип.ВладелецКонтактнойИнформации
//  ДатаАдреса                 - Дата, Неопределено - дата среза, на которую будет производиться поиск адреса
//  КонструкторЭД              - ОбработкаОбъект.ФорматДоговорныйДокумент101
//  
// Возвращаемое значение:
//  Строка - Значение кода страны.
//
Функция ЗаполнитьКодСтраныИностранногоАдреса(ВидКонтактнойИнформации, ОбъектКонтактнойИнформации, ДатаАдреса,
		КонструкторЭД) Экспорт
	
	КодСтраны = "";
	
	Если Не ЗначениеЗаполнено(ОбъектКонтактнойИнформации) Тогда
		Возврат КодСтраны;
	КонецЕсли;
	
	КонтактнаяИнформация = КонтактнаяИнформацияАдреса(ВидКонтактнойИнформации, ОбъектКонтактнойИнформации, ДатаАдреса);
	
	Если ЗначениеЗаполнено(КонтактнаяИнформация) Тогда
		
		АдресЗначение = КонтактнаяИнформация[0].Значение;
		Адрес = РаботаСАдресами.СведенияОбАдресе(АдресЗначение, Новый Структура("КодыАдреса", Ложь));
		
		Возврат Адрес.КодСтраны;

	КонецЕсли;

	Возврат КодСтраны;

КонецФункции

// Параметры:
//  ВидКонтактнойИнформации    - СправочникСсылка.ВидыКонтактнойИнформации - отбор по виду контактной информации.
//                             - ПеречислениеСсылка.ТипыКонтактнойИнформации - отбор по типу контактной информации.
//  ОбъектКонтактнойИнформации - ОпределяемыйТип.ВладелецКонтактнойИнформации
//  ДатаАдреса                 - Дата, Неопределено - дата среза, на которую будет производиться поиск адреса
//
// Возвращаемое значение:
//  ТаблицаЗначений:
//   * Объект           - ЛюбаяСсылка - владелец контактной информации.
//   * Вид              - СправочникСсылка.ВидыКонтактнойИнформации   - вид контактной информации.
//   * Тип              - ПеречислениеСсылка.ТипыКонтактнойИнформации - тип контактной информации.
//   * Значение         - Строка - контактная информация во внутреннем формате JSON.
//   * Представление    - Строка - представление контактной информации.
//   * Дата             - Дата   - дата, с которой действует запись контактной информации.
//   * ИдентификаторСтрокиТабличнойЧасти - Число - идентификатор строки этой табличной части
//   * ЗначенияПолей    - Строка - устаревший XML, соответствующий XDTO пакетам КонтактнаяИнформация или Адрес. Для
//                                  обратной совместимости.
//
Функция КонтактнаяИнформацияАдреса(ВидКонтактнойИнформации, ОбъектКонтактнойИнформации, ДатаАдреса) Экспорт
	
	ДатаАнализа = ?(ЗначениеЗаполнено(ДатаАдреса), ДатаАдреса, Неопределено);
	
	Если ТипЗнч(ВидКонтактнойИнформации) <> Тип("Массив") Тогда
		ВидыКонтактнойИнформации = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВидКонтактнойИнформации);
	Иначе
		ВидыКонтактнойИнформации = ВидКонтактнойИнформации;
	КонецЕсли;
	
	Для Каждого ПроверяемыйВид Из ВидыКонтактнойИнформации Цикл 
		КонтактнаяИнформация = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
			ОбъектКонтактнойИнформации, ПроверяемыйВид, ДатаАнализа, Ложь);
			
		Если КонтактнаяИнформация.Количество() Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;

	Возврат КонтактнаяИнформация;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ТекущаяИнформация = ИнформацияДокумента();
	ОшибкиЗаполнения = ОбработчикОшибок.ПроверитьЗаполнениеДанных(ТекущаяИнформация, ПроверяемыеРеквизиты);
	
	// Таблица 8.16
	Для Каждого СведенияИП Из ИдентификационныеСведенияИП Цикл
		
		Если Не ЗначениеЗаполнено(СведенияИП.ОГРН)
			И Не ЗначениеЗаполнено(СведенияИП.РеквизитыСвидетельстваОГосударственнойРегистрации) Тогда
				
			ПараметрыОшибки = ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки();
			ПараметрыОшибки.ТекстОшибки =
				НСтр("ru = 'Для ИП должны быть заполнены ОГРН или данные свидетельства о гос. регистрации.'");
			ОшибкиЗаполнения.Добавить(ПараметрыОшибки);
			Прервать;
		КонецЕсли;

	КонецЦикла;
	
	// Таблица 8.17
	Для Каждого СведенияИнЮЛ Из ИдентификационныеСведенияИностранногоЛица Цикл
		
		Если Не (ЗначениеЗаполнено(СведенияИнЮЛ.НаименованиеПолное) И ЗначениеЗаполнено(СведенияИнЮЛ.Идентификатор))
			И Не ЗначениеЗаполнено(СведенияИнЮЛ.УдостоверениеЛичностиИностранногоЛица) Тогда
				
			ПараметрыОшибки = ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки();
			ПараметрыОшибки.ТекстОшибки =
				НСтр("ru = 'Для иностранных лиц должны быть заполнены идентификатор ЮЛ и наименование полное 
				|или данные документа, удостоверяющего личность.'");
			ОшибкиЗаполнения.Добавить(ПараметрыОшибки);
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	// Таблица 8.27
	Для Каждого Адрес Из АдресФИАС Цикл
		
		Если Адрес.МуниципальныйРайон <> "99" Тогда
			ПараметрыОшибки = ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки();
			ПараметрыОшибки.ТекстОшибки =
				НСтр("ru = 'Для адресов в формате ФИАС должны быть обязательны указаны Муниципальный район/ 
				|городской округ/ внутригородская территория города федерального значения/ муниципальный округ.'");
			ОшибкиЗаполнения.Добавить(ПараметрыОшибки);
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ОшибкиЗаполнения) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращаемое значение:
//  Массив Из см. ОбщегоНазначенияБЭДКлиентСервер.НовыеПараметрыОшибки
//
Функция ПолучитьОшибкиЗаполнения() Экспорт
	Возврат ОшибкиЗаполнения;
КонецФункции

Процедура ЗаполнитьДанныеСопоставления(СоответствиеНоменклатуры) Экспорт

КонецПроцедуры

Функция СтрокиТребующиеСопоставления() Экспорт
	
	Возврат Новый Соответствие;

КонецФункции

// Параметры:
//  ДополнительныеДанные - см. ФорматыЭДО.НовыеДанныеДляФормированияОсновногоТитула 
//
Процедура УстановитьДополнительныеДанныеДляФормирования(ДополнительныеДанные) Экспорт
	ДополнительныеДанныеДляФормирования = ДополнительныеДанные;
КонецПроцедуры

// Возвращаемое значение:
//  см. ФорматыЭДО.НовыеДанныеДляФормированияОсновногоТитула
//
Функция ПолучитьДополнительныеДанныеДляФормирования() Экспорт
	Возврат ДополнительныеДанныеДляФормирования;
КонецФункции

#Область ФормированиеЭлектронногоДокумента

// Возвращаемое значение:
//  Строка
//
Функция ИдентификаторФайла() Экспорт
	
	ДанныеШаблона = Новый Структура;
	ДанныеШаблона.Вставить("ТипФайла", Менеджер.ПрефиксФормата());
	ДанныеШаблона.Вставить("Получатель",
		ПолучитьДополнительныеДанныеДляФормирования().Участники.ИдентификаторПолучателя);
	ДанныеШаблона.Вставить("Отправитель",
		ПолучитьДополнительныеДанныеДляФормирования().Участники.ИдентификаторОтправителя);
	ДанныеШаблона.Вставить("Дата", Формат(ДатаФормирования, "ДФ=yyyyMMdd"));
	
	ДанныеШаблона.Вставить("Пар1", ПолучитьДополнительныеДанныеДляФормирования().УникальныйИдентификатор); // УИД
	ДанныеШаблона.Вставить("Пар2", "1"); // Функция файла
	ДанныеШаблона.Вставить("Пар3", "00"); // Номер доп. соглашения
	ДанныеШаблона.Вставить("Пар4", "00"); // Номер прилагаемого файла
	ДанныеШаблона.Вставить("Пар5", "01"); // Порядковый номер
	
	Возврат СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(
		"[ТипФайла]_[Получатель]_[Отправитель]_[Дата]_[Пар1]_[Пар2]_[Пар3]_[Пар4]_[Пар5]", ДанныеШаблона);

КонецФункции

// АПК:216-выкл - Встречается элемент, содержащий кириллицу и латиницу в имени согласно схеме формата.

// Возвращаемое значение:
//  ФиксированнаяСтруктура:
//   * Файл          - Строка
//   * Документ      - Строка
//   * СвСодСдел     - Строка
//   * РекДок        - Строка
//   * СтороныДок    - Строка
//   * СвОбщСтДок    - Строка
//   * ПредметДок    - Строка
//   * УслПост       - Строка
//   * ПорРасч       - Строка
//   * СрокДок       - Строка
//   * СвязДок       - Строка
//   * КонтрТип      - Строка
//   * ИдСв          - Строка
//   * СвИП          - Строка
//   * СвЮЛУч        - Строка
//   * СвИнНеУч      - Строка
//   * СвФЛУч        - Строка
//   * Контакт       - Строка
//   * БанкРекв      - Строка
//   * ПодписантСт   - Строка
//   * СвДовер       - Строка
//   * СвДоверБум    - Строка
//   * СумАкцизТип   - Строка
//   * СумНДСТип     - Строка
//   * АдрДокТип     - Строка
//   * АдрКЛАДРТип   - Строка
//   * АдрФИАСТип    - Строка
//   * ВидНаимКодТип - Строка
//   * ВидНаимТип    - Строка
//   * ТипНаимТип    - Строка
//   * НомерТип      - Строка
//   * АдрИнфТип     - Строка
//   * УдЛичнФЛТип   - Строка
//   * УдЛичнИнФЛТип - Строка
//   * ИнфПолТип     - Строка
//   * ТекстИнфТип   - Строка
//   * ФИОТип        - Строка
//   * CCРФТип       - Строка
//   * БИКТип        - Строка
//   * ДатаТип       - Строка
//   * ИННФЛТип      - Строка
//   * ИННЮЛТип      - Строка
//   * КНДТип        - Строка
//   * КППТип        - Строка
//   * ОГРНИПТип     - Строка
//   * ОГРНТип       - Строка
//   * ОКВТип        - Строка
//   * ОКВЭДТип      - Строка
//   * ОКЕИТип       - Строка
//   * ОКПД2Тип      - Строка
//   * ОКСМТип       - Строка
//   * СПДУЛТип      - Строка
//   * СПДУЛШТип     - Строка
//
Функция ТипыОбъектов() Экспорт
	
	// BSLLS:Typo-off
	Типы = Новый Структура;
	ТипФайл = АнонимныйТип("Файл");
	Типы.Вставить("Файл", ТипФайл);
	ТипДокумент = АнонимныйТип("Файл.Документ");
	Типы.Вставить("Документ", ТипДокумент);
	ТипСведенияСделки = АнонимныйТип("Файл.Документ.СвСодСдел");
	Типы.Вставить("СвСодСдел", ТипСведенияСделки);
	ТипРеквизиты = АнонимныйТип("Файл.Документ.СвСодСдел.РекДок");
	Типы.Вставить("РекДок", ТипРеквизиты);
	ТипСтороны = АнонимныйТип("Файл.Документ.СвСодСдел.СтороныДок");
	Типы.Вставить("СтороныДок", ТипСтороны);
	ТипСведенияОСтоимости = АнонимныйТип("Файл.Документ.СвСодСдел.СвОбщСтДок");
	Типы.Вставить("СвОбщСтДок", ТипСведенияОСтоимости);
	ТипПредмет = АнонимныйТип("Файл.Документ.СвСодСдел.СвОбщСтДок.ПредметДок");
	Типы.Вставить("ПредметДок", ТипПредмет);
	ТипУсловияПоставки = АнонимныйТип("Файл.Документ.СвСодСдел.УслПост");
	Типы.Вставить("УслПост", ТипУсловияПоставки);
	ТипПорядокРасчетов = АнонимныйТип("Файл.Документ.СвСодСдел.ПорРасч");
	Типы.Вставить("ПорРасч", ТипПорядокРасчетов);
	ТипСрок = АнонимныйТип("Файл.Документ.СвСодСдел.СрокДок");
	Типы.Вставить("СрокДок", ТипСрок);
	ТипСвязанныйДок = АнонимныйТип("Файл.Документ.СвСодСдел.СвязДок");
	Типы.Вставить("СвязДок", ТипСвязанныйДок);
	Типы.Вставить("КонтрТип", "КонтрТип");
	Типы.Вставить("ИдСв", "КонтрТип.ИдСв");
	Типы.Вставить("СвИП", "КонтрТип.ИдСв.СвИП");
	Типы.Вставить("СвЮЛУч", "КонтрТип.ИдСв.СвЮЛУч");
	Типы.Вставить("СвИнНеУч", "КонтрТип.ИдСв.СвИнНеУч");
	Типы.Вставить("СвФЛУч", "КонтрТип.ИдСв.СвФЛУч");
	Типы.Вставить("Контакт", "КонтрТип.Контакт");
	Типы.Вставить("БанкРекв", "КонтрТип.БанкРекв");
	Типы.Вставить("ПодписантСт", "КонтрТип.ПодписантСт");
	Типы.Вставить("СвДовер", "КонтрТип.ПодписантСт.СвДовер");
	Типы.Вставить("СвДоверБум", "КонтрТип.ПодписантСт.СвДоверБум");
	Типы.Вставить("СумАкцизТип", "СумАкцизТип");
	Типы.Вставить("СумНДСТип", "СумНДСТип");
	Типы.Вставить("АдрДокТип", "АдрДокТип");
	Типы.Вставить("АдрКЛАДРТип", "АдрКЛАДРТип");
	Типы.Вставить("АдрФИАСТип", "АдрФИАСТип");
	Типы.Вставить("ВидНаимКодТип", "ВидНаимКодТип");
	Типы.Вставить("ВидНаимТип", "ВидНаимТип");
	Типы.Вставить("ТипНаимТип", "ТипНаимТип");
	Типы.Вставить("НомерТип", "НомерТип");
	Типы.Вставить("АдрИнфТип", "АдрИнфТип");
	Типы.Вставить("УдЛичнФЛТип", "УдЛичнФЛТип");
	Типы.Вставить("УдЛичнИнФЛТип", "УдЛичнИнФЛТип");
	Типы.Вставить("ИнфПолТип", "ИнфПолТип");
	Типы.Вставить("ТекстИнфТип", "ТекстИнфТип");
	Типы.Вставить("ФИОТип", "ФИОТип");
	Типы.Вставить("CCРФТип", "CCРФТип");
	Типы.Вставить("БИКТип", "БИКТип");
	Типы.Вставить("ДатаТип", "ДатаТип");
	Типы.Вставить("ИННФЛТип", "ИННФЛТип");
	Типы.Вставить("ИННЮЛТип", "ИННЮЛТип");
	Типы.Вставить("КНДТип", "КНДТип");
	Типы.Вставить("КППТип", "КППТип");
	Типы.Вставить("ОГРНИПТип", "ОГРНИПТип");
	Типы.Вставить("ОГРНТип", "ОГРНТип");	
	Типы.Вставить("ОКВТип", "ОКВТип");
	Типы.Вставить("ОКВЭДТип", "ОКВЭДТип");
	Типы.Вставить("ОКЕИТип", "ОКЕИТип");
	Типы.Вставить("ОКПД2Тип", "ОКПД2Тип");
	Типы.Вставить("ОКСМТип", "ОКСМТип");
	Типы.Вставить("СПДУЛТип", "СПДУЛТип");
	Типы.Вставить("СПДУЛШТип", "СПДУЛШТип");
	
	Возврат Новый ФиксированнаяСтруктура(Типы);
	// BSLLS:Typo-on
	
КонецФункции

// АПК:216-вкл

// Параметры:
//  ТипОбъекта - Строка - см. ТипыОбъектов
// 
// Возвращаемое значение:
//  ОбъектXDTO
//
Функция ПолучитьXDTOОбъект(ТипОбъекта) Экспорт
	Возврат РаботаСФайламиБЭД.ПолучитьОбъектТипаCML(ТипОбъекта, ПространствоИмен);
КонецФункции

#КонецОбласти

#Область Общее

// см. ОбработкаМенеджер.ФорматДоговорныйДокумент101.ПространствоИмен
//
Функция ПространствоИмен() Экспорт
	Возврат Менеджер.ПространствоИмен();
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция АнонимныйТип(Тип)
	Возврат СтрШаблон("{%1}.%2", ПространствоИмен, Тип);
КонецФункции

Процедура Инициализировать()
	
	Менеджер = Обработки.ФорматДоговорныйДокумент101;
	ПространствоИмен = ПространствоИмен();
	ДатаФормирования = ТекущаяДатаСеанса();
	ОбработчикОшибок.Инициализировать(ЭтотОбъект);
	ОшибкиЗаполнения = Новый Массив;
	
КонецПроцедуры

// см. Обработки.ФорматДоговорныйДокумент101.ТекстСправки
//
Функция ТекстСправки() Экспорт
	
	Возврат Менеджер.ТекстСправки();
	
КонецФункции

#КонецОбласти

#Область Инициализация

Инициализировать();

#КонецОбласти

#КонецЕсли

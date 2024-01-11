///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Задает настройки, применяемые как стандартные для объектов подсистемы.
//
// Параметры:
//   Настройки - Структура - коллекция настроек подсистемы. Реквизиты:
//       * ВыводитьОтчетыВместоВариантов - Булево - умолчание для вывода гиперссылок в панели отчетов:
//           Истина - варианты отчетов по умолчанию скрыты, а отчеты включены и видимы.
//           Ложь   - варианты отчетов по умолчанию видимы, а отчеты отключены.
//           Значение по умолчанию: Ложь.
//       * ВыводитьОписания - Булево - умолчание для вывода описаний в панели отчетов:
//           Истина - значение по умолчанию. Выводить описания в виде подписей под гиперссылками вариантов
//           Ложь   - выводить описания в виде всплывающих подсказок
//           Значение по умолчанию: Истина.
//       * Поиск - Структура - настройки поиска вариантов отчетов:
//           ** ПодсказкаВвода - Строка - текст подсказки выводится в поле поиска когда поиск не задан.
//               В качестве примера рекомендуется указывать часто используемые термины прикладной конфигурации.
//       * ДругиеОтчеты - Структура - настройки формы "Другие отчеты":
//           ** ЗакрыватьПослеВыбора - Булево - закрывать ли форму после выбора гиперссылки отчета.
//               Истина - закрывать "Другие отчеты" после выбора.
//               Ложь   - не закрывать.
//               Значение по умолчанию: Истина.
//           ** ПоказыватьФлажок - Булево - показывать ли флажок ЗакрыватьПослеВыбора.
//               Истина - показывать флажок "Закрывать это окно после перехода к другому отчету".
//               Ложь   - не показывать флажок.
//               Значение по умолчанию: Ложь.
//       * РазрешеноИзменятьВарианты - Булево - показывать расширенные настройки отчета
//               и команды изменения варианта отчета.
//
// Пример:
//	Настройки.Поиск.ПодсказкаВвода = НСтр("ru = 'Например, себестоимость'");
//	Настройки.ДругиеОтчеты.ЗакрыватьПослеВыбора = Ложь;
//	Настройки.ДругиеОтчеты.ПоказыватьФлажок = Истина;
//	Настройки.РазрешеноИзменятьВарианты = Ложь;
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	Настройки.ВыводитьОписания = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Настройки размещения отчетов

// Определяет разделы командного интерфейса, в которых предусмотрены панели отчетов.
// В Разделы необходимо добавить метаданные тех подсистем первого уровня,
// в которых размещены команды вызова панелей отчетов.
//
// Параметры:
//  Разделы - СписокЗначений - разделы, в которые выведены команды открытия панели отчетов:
//      * Значение - ОбъектМетаданныхПодсистема
//                 - Строка - подсистема раздела глобального командного интерфейса,
//                   либо ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы для начальной страницы.
//      * Представление - Строка - заголовок панели отчетов в этом разделе.
//
// Пример:
//	Разделы.Добавить(Метаданные.Подсистемы.Анкетирование, НСтр("ru = 'Отчеты по анкетированию'"));
//	Разделы.Добавить(ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы(), НСтр("ru = 'Основные отчеты'"));
//
Процедура ОпределитьРазделыСВариантамиОтчетов(Разделы) Экспорт
	
	Разделы.Добавить(ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы(), НСтр("ru = 'Основные отчеты'"));
	Разделы.Добавить(Метаданные.Подсистемы.CRM, НСтр("ru = 'CRM'"));
	Разделы.Добавить(Метаданные.Подсистемы.Продажи, НСтр("ru = 'Продажи'"));
	Разделы.Добавить(Метаданные.Подсистемы.Закупки, НСтр("ru = 'Закупки'"));
	Разделы.Добавить(Метаданные.Подсистемы.Склад, НСтр("ru = 'Склад'"));
	Разделы.Добавить(Метаданные.Подсистемы.Работы, НСтр("ru = 'Работы'"));
	Разделы.Добавить(Метаданные.Подсистемы.Производство, НСтр("ru = 'Производство'"));
	Разделы.Добавить(Метаданные.Подсистемы.Деньги, НСтр("ru = 'Деньги'"));
	Разделы.Добавить(Метаданные.Подсистемы.Персонал, НСтр("ru = 'Персонал'"));
	Разделы.Добавить(Метаданные.Подсистемы.Компания, НСтр("ru = 'Компания'"));
	Разделы.Добавить(Метаданные.Подсистемы.ЗарплатаКадрыРегламентированныеУНФ,
		НСтр("ru = 'Зарплата и кадры (регламентированные)'"));	
	
КонецПроцедуры

// Задает расширенные настройки отчетов конфигурации, такие как:
// - описание отчета;
// - поля поиска: наименования полей, параметров и отборов (для отчетов не на базе СКД);
// - размещение в разделах командного интерфейса
//   (начальная настройка размещения отчетов по подсистемам автоматически определяется из метаданных,
//    ее дублирование не требуется);
// - признак Включен (для контекстных отчетов);
// - режима вывода в панелях отчетов (с группировкой по отчету или без);
// - и другие.
// 
// В процедуре задаются только настройки отчетов (и вариантов отчетов) конфигурации.
// Для настройки отчетов из расширений конфигурации следует включать их в подсистему ПодключаемыеОтчетыИОбработки.
//
// Для задания настроек следует использовать следующие вспомогательные процедуры и функции:
//   ВариантыОтчетов.ОписаниеОтчета, 
//   ВариантыОтчетов.ОписаниеВарианта, 
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов, 
//   ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера.
//
// Изменяя настройки отчета, можно изменить настройки всех его вариантов.
// Однако, если явно получить настройки варианта отчета, то они станут самостоятельными,
// т.е. более не будут наследовать изменения настроек от отчета.
//   
// Функциональные опции предопределенного варианта отчета объединяются с функциональными опциями этого отчета по правилам:
// (ФО1_Отчета ИЛИ ФО2_Отчета) И (ФО3_Варианта ИЛИ ФО4_Варианта).
// При этом для пользовательских вариантов отчета действуют только функциональные опции отчета
// - они отключаются только с отключением всего отчета.
//
// Параметры:
//   Настройки - ТаблицаЗначений - коллекция предопределенных вариантов отчетов, где:
//       * Отчет - СправочникСсылка.ИдентификаторыОбъектовРасширений
//               - СправочникСсылка.ДополнительныеОтчетыИОбработки
//               - СправочникСсылка.ИдентификаторыОбъектовМетаданных
//               - Строка - полное имя или ссылка на идентификатор отчета.
//       * Метаданные - ОбъектМетаданныхОтчет - метаданные отчета.
//       * ИспользуетСКД - Булево - признак использования в отчете основной СКД.
//       * КлючВарианта - Строка - идентификатор варианта отчета.
//       * ОписаниеПолучено - Булево - признак того, что описание строки уже получено.
//       * Включен              - Булево - если Ложь, то вариант отчета не выводится в панели отчетов.
//       * ВидимостьПоУмолчанию - Булево - если Ложь, то вариант отчета по умолчанию скрыт в панели отчетов.
//       * ПоказыватьВПодменюВариантов - Булево - если Ложь, то вариант отчета не отображается в подменю выбора вариантов  
//                                                отчета в форме отчета. Используется, когда Включен - Ложь.
//       * Наименование - Строка - наименование варианта отчета.
//       * Описание - Строка - пояснение назначения отчета.
//       * Размещение - Соответствие из КлючИЗначение - настройки размещения варианта отчета в разделах (подсистемах), где:
//             ** Ключ - ОбъектМетаданных - подсистема, в которой размещается отчет или вариант отчета.
//             ** Значение - Строка - настройки размещения в подсистеме (группе) - "", "Важный", "СмТакже".
//       * НастройкиДляПоиска - Структура - дополнительные настройки для поиска этого варианта отчета, где:
//             ** НаименованияПолей - Строка - имена полей варианта отчета.
//             ** НаименованияПараметровИОтборов - Строка - имена настроек варианта отчета.
//             ** КлючевыеСлова - Строка - дополнительная терминология (в т.ч. специализированная или устаревшая).
//             ** ИменаМакетов - Строка - используется вместо НаименованияПолей.
//       * СистемнаяИнформация - Структура - другая служебная информация.
//       * Тип - Строка - перечень идентификаторов типов.
//       * ЭтоВариант - Булево - признак того, что описание отчета относится к варианту отчета.
//       * ФункциональныеОпции - Массив из Строка - коллекция идентификаторов функциональных опций, где:
//       * ГруппироватьПоОтчету - Булево - признак необходимости группировки вариантов по отчету-основанию.
//       * КлючЗамеров - Строка - идентификатор замера производительности отчета.
//       * ОсновнойВариант - Строка - идентификатор основного варианта отчета.
//       * ФорматНастроекСКД - Булево - признак хранения настроек в формате СКД.
//       * ОпределитьНастройкиФормы - Булево - отчет имеет программный интерфейс для тесной интеграции с формой отчета,
//           в том числе может переопределять некоторые настройки формы и подписываться на ее события.
//           Если Истина и отчет подключен к общей форме ФормаОтчета,
//           тогда в модуле объекта отчета следует определить процедуру по шаблону:
//               
//               // Задать настройки формы отчета.
//               //
//               // Параметры:
//               //   Форма - ФормаКлиентскогоПриложения, Неопределено
//               //   КлючВарианта - Строка, Неопределено
//               //   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//               //
//               Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
//               	// Код процедуры.
//               КонецПроцедуры
//
// Пример:
//
//  // Добавление варианта отчета в подсистему.
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Размещение.Вставить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
//  // Отключение варианта отчета.
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Включен = Ложь;
//
//  // Отключение всех вариантов отчета, кроме одного.
//	НастройкиОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	НастройкиОтчета.Включен = Ложь;
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Включен = Истина;
//
//  // Заполнение настроек для поиска - наименования полей, параметров и отборов:
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчетаБезСхемы, "");
//	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей =
//		НСтр("ru = 'Контрагент
//		|Договор
//		|Ответственный
//		|Скидка
//		|Дата'");
//	НастройкиВарианта.НастройкиДляПоиска.НаименованияПараметровИОтборов =
//		НСтр("ru = 'Период
//		|Ответственный
//		|Контрагент
//		|Договор'");
//
//  // Переключение режима вывода в панелях отчетов:
//  // Группировка вариантов отчета по этому отчету:
//	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Метаданные.Отчеты.ИмяОтчета, Истина);
//  // Без группировки по отчету:
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Отчет, Ложь);
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	// Отчеты БСП
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ПроверкаЦелостностиТома, "Основной");
	Вариант.Включен = Ложь;
	Вариант.Размещение.Очистить();
	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СогласияНаОбработкуПерсональныхДанныхДействующие);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СогласияНаОбработкуПерсональныхДанныхИстекающие);
	
	Вариант = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИспользуемыеВнешниеРесурсы);
	Вариант.Включен = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СведенияОПользователях, "СведенияОПользователяхИВнешнихПользователях");
	Вариант.Включен = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СведенияОПользователях, "СведенияОПользователях");
	Вариант.Включен = Ложь;
	
	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.СведенияОПользователях, "СведенияОВнешнихПользователях");
	Вариант.Включен = Ложь;
	
	ПроверкаКонтрагентовБРО.НастроитьВариантыОтчетов(Настройки);
	
	// ГосИС
	ОтчетыЕГАИС.НастроитьВариантыОтчетов(Настройки);
	ОтчетыИСМП.НастроитьВариантыОтчетов(Настройки);
	ИнтеграцияВЕТИСУНФ.НастроитьВариантыОтчетов(Настройки);
	
	// Настройки выполняются в модуле менеджера отчета
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ABCXYZАнализПродаж);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ABCАнализПродаж);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АвтоматическиеСкидки);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АктСверки);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализБазыКонтрагентов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализБазыЛидов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализБизнеса);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализДоступности);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализЗаказаПокупателя);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализЗаказаПоставщику);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализЗаказовПокупателей);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализНачисленийБонусныхБаллов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализОплатыПоЗаказамПокупателей);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализОплатыПоЗаказамПоставщикам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализПотребности);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализРаботыМенеджеров);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализСчетовИЗаказовВВалютеУчета);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализСчетовНаОплату);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.АнализСчетовНаОплатуПоставщиков);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.Баланс);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.БюджетДвиженияДенежныхСредств);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.БюджетПрибылейИУбытков);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьПоТоварамНаСкладахВЦенахНоменклатуры);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.Взаиморасчеты);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВнеоборотныеАктивы);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВоронкаПоЛидам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВоронкаПродаж);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВыполнениеДоговоровОбслуживания);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВыпускПродукции);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВыработкаВнеоборотныхАктивов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ГрафикДвиженияЗапасов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДвижениеДенежныхСредств);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДвижениеПодарочныхСертификатов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДвижениеТоваров);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДвиженияБонусныхБаллов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДвиженияСерийНоменклатуры);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДенежныеСредства);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДенежныеСредстваВКассахККМ);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДенежныеСредстваКПоступлению);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДенежныеСредстваПрогноз);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДенежныйПоток);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДинамикаЗадолженностиПокупателей);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДинамикаЗадолженностиПоставщикам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.Долги);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДоходыИРасходы);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДоходыИРасходыКассовымМетодом);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДоходыИРасходыПрогноз);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДоходыРасходы);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЖурналУчетаВыданныхПокупателюДокументов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЖурналУчетаПродажиАлкогольнойПродукции);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЗаданияНаРаботу);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЗаказыНаПеремещение);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЗаказыНаПроизводство);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЗаказыПокупателей);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЗаказыПоставщикам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЗакрытиеМесяца);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЗакрытиеМесяцаАнализОтрицательныхОстатков);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.Закупки);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.Запасы);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЗапасыВРазрезеГТД);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЗапасыПереданные);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЗапасыПереданныеВРазрезеГТД);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЗапасыПринятые);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЗапасыПринятыеВРазрезеГТД);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ИзлишкиИНедостачи);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.КалендарьСобытий);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.КонтрольЗаполненияКонтактнойИнформации);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.КонтрольОперацийЭквайринга);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.НачисленияИУдержания);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.НЗП);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.НормативныйСоставИзделия);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОборачиваемостьЗапасов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОборотноСальдоваяВедомость);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОплатаПлатежнымиКартами);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОстаткиБонусныхБаллов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОстаткиНаборов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОстаткиНоменклатурыПоставщиковДляОбменаССайтом);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОстаткиПодарочныхСертификатов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОстаткиТоваров);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОстаткиТоваровМеньшеНуля);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОстаткиТоваровПоСрокамГодности);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОтработанноеВремя);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПересеченияСегментов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПланируемыеОстаткиДС);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПлановыеДвиженияДенежныхСредств);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПланФактныйАнализПродаж);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПланФактныйАнализПроизводства);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПланФактныйАнализСебестоимостиВыпуска);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПланыПродаж);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПлатежныйКалендарь);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПрибылиИУбытки);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПримененныеСкидкиОценка);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПримененныеСкидкиСтатистика);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПричиныОтменыЗаказаПокупателя);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПричиныОтменыЗаказаПоставщику);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПрогнозныйБаланс);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.Продажи);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПродажиОстаткиТовараВДняхТорговли);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПродажиПоДисконтнымКартам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РазмещениеЗаказов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РаспределениеМатериалов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.Расходы);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетнаяВедомость);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетныеЛистки);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетыПоКредитамИЗаймам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетыПоНалогам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетыПоПрочимОперациям);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетыПоЭквайрингу);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетыСКомиссионерами);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетыСКомитентами);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетыСПерсоналом);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетыСПодотчетниками);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетыСПокупателями);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасчетыСПоставщиками);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасшифровкаАнализаЗакрытияМесяца);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РеестрОплатЗаказовИСчетов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РеестрСтаренияДебиторскойЗадолженности);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РеестрСтаренияКредиторскойЗадолженности);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РезервыТоваровОрганизаций);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РозничныеПродажи);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СводныйАнализЗаказовПокупателей);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СводныйАнализЗаказовПоставщикам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СдельныеНаряды);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.Себестоимость);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.Склад);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СкладПоЗапасамВРемонте);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СкладПоСериямНоменклатуры);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СлужебныйОтчетДобавлениеВПанельОтчетов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СоставКомплектов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СоставНаборов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СоставСегмента);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СпискиСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СуммовойУчетВРознице);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ТоварныйОтчетТОРГ29);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.Траты);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.УплатыНалоговИВзносов);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ФинансовыйРезультат);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ФинансовыйРезультатПрогноз);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.Ценообразование_СравнениеЦенЗаПериод);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.Ценообразование_ЦенаИзПоследнегоПоступления);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.Ценообразование_ЦенаИзПоследнейРеализации);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ЧистыеАктивы);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ШтатноеРасписание);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасшифровкаНачисленийПремийПродавцам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДействующиеПравилаРасчетаПремий);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ИспользованиеРабочегоВремени);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПланФактПоРабочемуВремениСотрудников);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОрдерныеСклады);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОтчетПоЧекам);
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СтатистикаЧеков);
	
	// БЗКБ ЗарплатаКадрыПодсистемы
	ЗарплатаКадрыОтчеты.НастроитьВариантыОтчетов(Настройки);
	ИнтеграцияБЗКБУНФ.НастроитьВариантыОтчетов(Настройки);
	// Конец БЗКБ ЗарплатаКадрыПодсистемы
	
КонецПроцедуры

// Регистрирует изменения в именах вариантов отчетов.
//   Используется при обновлении в целях сохранения ссылочной целостности,
//   в частности для сохранения пользовательских настроек и настроек рассылок отчетов.
//   Старое имя варианта резервируется и не может быть использовано в дальнейшем.
//   Если изменений было несколько, то каждое изменение необходимо зарегистрировать,
//   указывая в актуальном имени варианта последнее (текущее) имя варианта отчета.
//   Поскольку имена вариантов отчетов не выводятся в пользовательском интерфейсе,
//   то рекомендуется задавать их таким образом, что бы затем не менять.
//   В Изменения необходимо добавить описания изменений имен вариантов
//   отчетов, подключенных к подсистеме.
//
// Параметры:
//   Изменения - ТаблицаЗначений - таблица изменений имен вариантов. Колонки:
//       * Отчет - ОбъектМетаданных - метаданные отчета, в схеме которого изменилось имя варианта.
//       * СтароеИмяВарианта - Строка - старое имя варианта, до изменения.
//       * АктуальноеИмяВарианта - Строка - текущее (последнее актуальное) имя варианта.
//
// Пример:
//	Изменение = Изменения.Добавить();
//	Изменение.Отчет = Метаданные.Отчеты.<ИмяОтчета>;
//	Изменение.СтароеИмяВарианта = "<СтароеИмяВарианта>";
//	Изменение.АктуальноеИмяВарианта = "<АктуальноеИмяВарианта>";
//
Процедура ЗарегистрироватьИзмененияКлючейВариантовОтчетов(Изменения) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Настройки команд отчетов

// Определяет объекты конфигурации, в модулях менеджеров которых предусмотрена процедура ДобавитьКомандыОтчетов,
// описывающая команды открытия контекстных отчетов.
// Синтаксис процедуры ДобавитьКомандыОтчетов см. в документации.
//
// Параметры:
//   Объекты - Массив - объекты метаданных (ОбъектМетаданных) с командами отчетов.
//
Процедура ОпределитьОбъектыСКомандамиОтчетов(Объекты) Экспорт
	
	// ГосИС
	ИнтеграцияИС.ОпределитьОбъектыСКомандамиОтчетов(Объекты);
	// Конец ГосИС
	
КонецПроцедуры

// Определение списка глобальных команд отчетов.
// Событие возникает в процессе вызова модуля повторного использования.
//
// Параметры:
//  КомандыОтчетов - ТаблицаЗначений - таблица команд для вывода в подменю, где:
//   * Идентификатор - Строка   - идентификатор команды.
//   * Представление - Строка   - представление команды в форме.
//   * Важность      - Строка   - суффикс группы в подменю, в которой следует вывести эту команду.
//                                Допустимо использовать: "Важное", "Обычное" и "СмТакже".
//   * Порядок       - Число    - порядок размещения команды в группе. Используется для настройки под конкретное
//                                рабочее место.
//   * Картинка      - Картинка - картинка команды.
//   * СочетаниеКлавиш - СочетаниеКлавиш - сочетание клавиш для быстрого вызова команды.
//   * ТипПараметра - ОписаниеТипов - типы объектов, для которых предназначена эта команда.
//   * ВидимостьВФормах    - Строка - имена форм через запятую, в которых должна отображаться команда.
//                                    Используется когда состав команд отличается для различных форм.
//   * ФункциональныеОпции - Строка - имена функциональных опций через запятую, определяющих видимость команды.
//   * УсловияВидимости    - Массив - определяет видимость команды в зависимости от контекста.
//                                    Для регистрации условий следует использовать процедуру
//                                    ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды().
//                                    Условия объединяются по "И".
//   * ИзменяетВыбранныеОбъекты - Булево - определяет доступность команды в ситуации,
//                                         когда у пользователя нет прав на изменение объекта.
//                                         Если Истина, то в описанной выше ситуации кнопка будет недоступна.
//                                         Необязательный. Значение по умолчанию: Ложь.
//   * МножественныйВыбор - Булево
//                        - Неопределено - если Истина, то команда поддерживает множественный выбор.
//                                         В этом случае в параметре выполнения будет передан список ссылок.
//                                         Необязательный. Значение по умолчанию: Истина.
//   * РежимЗаписи - Строка - действия, связанные с записью объекта, которые выполняются перед обработчиком команды, где:
//                 "НеЗаписывать" - объект не записывается, а в параметрах обработчика вместо ссылок передается
//                                  вся форма. В этом режиме рекомендуется работать напрямую с формой,
//                                  которая передается в структуре 2 параметра обработчика команды.
//                 "ЗаписыватьТолькоНовые" - записывать новые объекты.
//                 "Записывать"            - записывать новые и модифицированные объекты.
//                 "Проводить"             - проводить документы.
//                 Перед записью и проведением у пользователя запрашивается подтверждение.
//                 Необязательный. Значение по умолчанию: "Записывать".
//   * ТребуетсяРаботаСФайлами - Булево - если Истина, то в веб-клиенте предлагается
//                                        установить расширение для работы с 1С:Предприятием.
//                                        Необязательный. Значение по умолчанию: Ложь.
//   * Менеджер - Строка - полное имя объекта метаданных, отвечающего за выполнение команды.
//                         Например, "Отчет._ДемоКнигаПокупок".
//   * ИмяФормы - Строка - имя формы, которую требуется открыть или получить для выполнения команды.
//                         Если Обработчик не указан, то у формы вызывается метод "Открыть".
//   * КлючВарианта - Строка - имя варианта отчета, открываемого при выполнении команды.
//   * ИмяПараметраФормы - Строка - имя параметра формы, в который следует передать ссылку или массив ссылок.
//   * ПараметрыФормы - Неопределено
//                    - Структура - параметры формы, указанной в ИмяФормы.
//   * Обработчик - Строка - описание процедуры, обрабатывающей основное действие команды.
//                  Формат "<ИмяОбщегоМодуля>.<ИмяПроцедуры>" используется когда процедура размещена в общем модуле.
//                  Формат "<ИмяПроцедуры>" используется в следующих случаях:
//                  1) если ИмяФормы заполнено то в модуле указанной формы ожидается клиентская процедура,
//                  2) если ИмяФормы не заполнено то в модуле менеджера этого объекта ожидается серверная процедура.
//   * ДополнительныеПараметры - Структура - параметры обработчика, указанного в Обработчик.
//
//  Параметры - Структура - сведения о контексте исполнения, где:
//   * ИмяФормы - Строка - полное имя формы.
//   
//  СтандартнаяОбработка - Булево - если установить в Ложь, то событие "ДобавитьКомандыОтчетов" менеджера объекта не
//                                  будет вызвано.
//
Процедура ПередДобавлениемКомандОтчетов(КомандыОтчетов, Параметры, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

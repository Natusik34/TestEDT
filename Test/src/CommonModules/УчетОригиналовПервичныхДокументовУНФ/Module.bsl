#Область ПрограммныйИнтерфейс

// Обработчик события "ПриСозданииНаСервере" формы документа.
//
//	Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма списка документа.
//
Процедура ПриСозданииНаСервере_ФормаДокумента(Форма) Экспорт

	Если СледуетСкрытьГруппуСостояниеОригинала() Тогда
		Форма.Элементы.ГруппаСостояниеОригинала.Видимость = Ложь;
		Возврат;
	КонецЕсли;

	НастроитьГруппуСостояниеОригинала(Форма);

	Счетчик = 0;

	Для Каждого ТекСостояние Из УчетОригиналовПервичныхДокументов.ИспользуемыеСостояния() Цикл

		Форма.СписокВыбораСостоянийОригинала.Добавить(ТекСостояние.Ссылка, ТекСостояние.Наименование);

		ИмяКоманды = СтрШаблон("%1%2",
			УчетОригиналовПервичныхДокументовУНФКлиентСервер.ПрефиксКомандыИзменитьСостояниеОригинала(), XMLСтрока(
			Счетчик));

		НоваяКоманда = Форма.Команды.Добавить(ИмяКоманды);
		НоваяКоманда.Действие = "Подключаемый_ИзменитьСостояниеОригинала";
		НоваяКоманда.Заголовок = ТекСостояние.Наименование;

		НоваяКнопка = Форма.Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Форма.Элементы.ГруппаСостояниеОригинала);
		НоваяКнопка.ИмяКоманды = ИмяКоманды;
		НоваяКнопка.Картинка = УчетОригиналовПервичныхДокументовУНФКлиентСервер.КартинкаСостояния(ТекСостояние.Ссылка,
			Новый Картинка);

		Счетчик = Счетчик + 1;

	КонецЦикла;

	ДобавитьКомандуУточнитьПоПечатнымФормам(Форма, Счетчик);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьГруппуСостояниеОригинала(Форма)

	СостояниеОригиналаПервичногоДокумента = СостояниеОригиналаПервичногоДокумента(Форма.Объект.Ссылка);

	Форма.Элементы.ГруппаСостояниеОригинала.Картинка = УчетОригиналовПервичныхДокументовУНФКлиентСервер.КартинкаСостояния(
		СостояниеОригиналаПервичногоДокумента,
		БиблиотекаКартинок.СостояниеОригиналаПервичногоДокументаОригиналНеПолучен);

	ПредставлениеСостояния = УчетОригиналовПервичныхДокументовУНФКлиентСервер.ПредставлениеСостояния(
		СостояниеОригиналаПервичногоДокумента);

	Если ЗначениеЗаполнено(ПредставлениеСостояния) Тогда
		Форма.Элементы.ГруппаСостояниеОригинала.Заголовок = ПредставлениеСостояния;
		Форма.Элементы.ГруппаСостояниеОригинала.Отображение = ОтображениеКнопки.КартинкаИТекст;
	Иначе
		Форма.Элементы.ГруппаСостояниеОригинала.Заголовок = НСтр("ru = 'Состояние оригинала'");
		Форма.Элементы.ГруппаСостояниеОригинала.Отображение = ОтображениеКнопки.Картинка;
	КонецЕсли;

КонецПроцедуры

Функция СостояниеОригиналаПервичногоДокумента(ДокументСсылка)

	ТекущееСостояниеОригинала = УчетОригиналовПервичныхДокументов.СведенияОСостоянииОригиналаПоСсылке(ДокументСсылка);

	Если ТипЗнч(ТекущееСостояниеОригинала) <> Тип("Структура") Тогда
		Возврат Справочники.СостоянияОригиналовПервичныхДокументов.ПустаяСсылка();
	КонецЕсли;

	Если Не ТекущееСостояниеОригинала.Свойство("СостояниеОригиналаПервичногоДокумента") Тогда
		Возврат Справочники.СостоянияОригиналовПервичныхДокументов.ПустаяСсылка();
	КонецЕсли;

	Возврат ТекущееСостояниеОригинала.СостояниеОригиналаПервичногоДокумента;

КонецФункции

Функция СледуетСкрытьГруппуСостояниеОригинала()

	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетОригиналовПервичныхДокументов") Тогда
		Возврат Истина;
	КонецЕсли;

	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыСведений.СостоянияОригиналовПервичныхДокументов) Тогда
		Возврат Истина;
	КонецЕсли;

	Возврат Ложь;

КонецФункции

Процедура ДобавитьКомандуУточнитьПоПечатнымФормам(Форма, Счетчик)

	Форма.СписокВыбораСостоянийОригинала.Добавить(
		УчетОригиналовПервичныхДокументовУНФКлиентСервер.УточнитьПоПечатнымФормам());

	ИмяКоманды = СтрШаблон("%1%2",
		УчетОригиналовПервичныхДокументовУНФКлиентСервер.ПрефиксКомандыИзменитьСостояниеОригинала(), XMLСтрока(Счетчик));

	НоваяКоманда = Форма.Команды.Добавить(ИмяКоманды);
	НоваяКоманда.Действие = "Подключаемый_ИзменитьСостояниеОригинала";
	НоваяКоманда.Заголовок = УчетОригиналовПервичныхДокументовУНФКлиентСервер.УточнитьПоПечатнымФормамЗаголовок();

	НоваяКнопка = Форма.Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Форма.Элементы.ГруппаСостояниеОригинала);
	НоваяКнопка.ИмяКоманды = ИмяКоманды;
	НоваяКнопка.Картинка = БиблиотекаКартинок.УточнитьСостояниеОригиналаПервичногоДокументаПоПечатнымФормам;

КонецПроцедуры

#КонецОбласти
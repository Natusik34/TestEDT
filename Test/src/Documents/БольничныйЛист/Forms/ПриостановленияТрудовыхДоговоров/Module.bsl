#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресСтруктурыБольничного = Параметры.АдресСтруктурыБольничного;
	
	Больничный = ПолучитьИзВременногоХранилища(АдресСтруктурыБольничного);
	ЗаполнитьФормуПоДаннымБольничного(Больничный);
	
	// АПК:278-выкл Вызов в пределах библиотеки.
	Заголовок = СтрШаблон(
		НСтр("ru = 'Приостановления трудовых договоров для расчета больничного %1'"),
		ОбщегоНазначенияБЗК.НаименованиеПериода(ДатаНачала, ДатаОкончания));
	
	Оформление = ОбщегоНазначенияБЗК.ДобавитьУсловноеОформление(ЭтотОбъект, "ТаблицаОтступ, ТаблицаОшибка, ТаблицаТекстОшибки");
	ОбщегоНазначенияБЗК.ДобавитьОтборУсловногоОформления(Оформление, "Таблица.Ошибка", "=", Ложь);
	ОбщегоНазначенияБЗК.УстановитьПараметрУсловногоОформления(Оформление, "Отображать", Ложь);
	ОбщегоНазначенияБЗК.УстановитьПараметрУсловногоОформления(Оформление, "Видимость", Ложь);
	// АПК:278-вкл
	
	РеквизитыТаблицы = Метаданные.Документы.БольничныйЛист.ТабличныеЧасти.ПриостановленияТрудовыхДоговоров.Реквизиты;
	Свойства = Новый Структура("Подсказка, ПараметрыВыбора");
	Для Каждого Реквизит Из РеквизитыТаблицы Цикл
		ПолеВвода = Элементы.Найти("Таблица" + Реквизит.Имя);
		Если ТипЗнч(ПолеВвода) = Тип("ПолеФормы") Тогда
			ЗаполнитьЗначенияСвойств(Свойства, Реквизит);
			ЗаполнитьЗначенияСвойств(ПолеВвода, Свойства);
		КонецЕсли;
	КонецЦикла;
	
	ДоступнаРасширеннаяРеализация = ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыРасширеннаяПодсистемы");
	Элементы.КнопкаЗаполнить.Видимость = ЗначениеЗаполнено(ГоловнаяОрганизация)
		И ЗначениеЗаполнено(ФизическоеЛицо)
		И ДоступнаРасширеннаяРеализация;
	
	ПроверитьЗаполнение();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	УчетПособийСоциальногоСтрахования.ПроверитьПриостановленияТрудовыхДоговоров(
		ЭтотОбъект,
		Таблица);
	Если Таблица.НайтиСтроки(Новый Структура("Ошибка", Истина)).Количество() > 0 Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблица

&НаКлиенте
Процедура ТаблицаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	Автозаполнение = Ложь;
	ПодключитьОбработчикОжидания("ПроверитьНастройкиПользователя", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПриИзменении(Элемент)
	Автозаполнение = Ложь;
	ПодключитьОбработчикОжидания("ПроверитьНастройкиПользователя", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПередУдалением(Элемент, Отказ)
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	Автозаполнение = Ложь;
	ПодключитьОбработчикОжидания("ПроверитьНастройкиПользователя", 0.1, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	Если Не ПроверитьНастройкиПользователя() Тогда
		Возврат;
	КонецЕсли;
	ОповеститьОВыборе(РезультатВыбора());
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьФормуПоДаннымБольничного(Больничный)
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Больничный);
	Таблица.Загрузить(Больничный.ПриостановленияТрудовыхДоговоров);
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		СтрокаТаблицы.Год = Год(СтрокаТаблицы.ДатаНачала);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция ПроверитьНастройкиПользователя()
	Возврат ПроверитьЗаполнение();
КонецФункции

&НаСервере
Процедура ЗаполнитьНаСервере()
	Автозаполнение = Истина;
	Таблица.Загрузить(УчетПособийСоциальногоСтрахования.ПриостановленияТрудовыхДоговоров(ЭтотОбъект));
	ПроверитьЗаполнение();
КонецПроцедуры

&НаКлиенте
Функция РезультатВыбора()
	ТаблицаМассивом = Новый Массив;
	ИменаПолей = "ДатаНачала, ДатаОкончания, КалендарныхДней, ОснованиеНПА";
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Структура = Новый Структура(ИменаПолей);
		ЗаполнитьЗначенияСвойств(Структура, СтрокаТаблицы, ИменаПолей);
		ТаблицаМассивом.Добавить(Структура);
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("ПриостановленияТрудовыхДоговоров", ТаблицаМассивом);
	Результат.Вставить("Автозаполнение", Автозаполнение);
	Возврат Результат;
КонецФункции

#КонецОбласти

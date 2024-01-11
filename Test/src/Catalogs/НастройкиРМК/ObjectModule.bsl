#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ГруппыКатегории = 0 Тогда
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "РаспределениеНоменклатуры.КатегорияНоменклатуры");
	Иначе
		ЗаполнениеОбъектовУНФ.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "РаспределениеНоменклатуры.ГруппаНоменклатуры");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНовоеРМК") Тогда
		
		ТекущееРабочееМесто = ПараметрыСеанса.РабочееМестоКлиента;
		
		Если НЕ ЗначениеЗаполнено(ТекущееРабочееМесто) Тогда
			ТекущееРабочееМесто = МенеджерОборудованияВызовСервера.РабочееМестоКлиента();
		КонецЕсли;
		
		ДоступныеНастройкиРМК = ОбщегоНазначенияРМК.НастройкиРМКДляТекущегоРабочегоМеста(ТекущееРабочееМесто);
		КоличествоДоступныхНастроек = ДоступныеНастройкиРМК.Количество();
		
		ПродажиСНесколькихКассККМ = Ложь;
		ОсновнаяКассаККМ = Неопределено;
		Если КоличествоДоступныхНастроек = 1 И ЗначениеЗаполнено(ДоступныеНастройкиРМК[0]) Тогда
			ПродажиСНесколькихКассККМ = ДоступныеНастройкиРМК[0].ПродажиСНесколькихКассККМ;
			ОсновнаяКассаККМ = ДоступныеНастройкиРМК[0].ОсновнаяКассаККМ;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		ОбщегоНазначенияРМКУНФ.СформироватьЗапросДанныеКассыККМ(Запрос, ЭтотОбъект);
		Если Не ЗначениеЗаполнено(Запрос.Текст) Тогда
			ТекстСообщения = НСтр("ru = 'Не сформирован запрос для получения данных Касс ККМ'");
			Отказ = Истина;
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
		
		ТаблицаДоступныхКассККМ = Запрос.Выполнить().Выгрузить();
		Если НЕ ПродажиСНесколькихКассККМ Тогда
			КоличествоДоступныхКассККМ = ТаблицаДоступныхКассККМ.Количество();
			Если КоличествоДоступныхКассККМ > 0 Тогда
				Для НомерСтрокиТаблицы = 1 По КоличествоДоступныхКассККМ-1 Цикл
					ТаблицаДоступныхКассККМ.Удалить(КоличествоДоступныхКассККМ-НомерСтрокиТаблицы);
				КонецЦикла;
				ОсновнаяКассаККМ = ТаблицаДоступныхКассККМ[0].КассаККМ;
			КонецЕсли;
		КонецЕсли;
		
		МассивКассККМРаспределения = Новый Массив;
		МассивКассККМРаспределения.Добавить(ОсновнаяКассаККМ);
		
		Для Каждого СтрокаРаспределения Из РаспределениеНоменклатуры Цикл
			
			Если СтрокаРаспределения.КассаККМ.Пустая() Тогда
				Продолжить;
			КонецЕсли;
			
			ДоступнаяКассаККМ = ТаблицаДоступныхКассККМ.Найти(СтрокаРаспределения.КассаККМ, "КассаККМ");
			Если ДоступнаяКассаККМ = Неопределено Тогда
				ТекстСообщения = 
					НСтр("ru = 'Касса ККМ недоступна или не используется для текущего рабочего места.'");
				КонтекстноеПоле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("РаспределениеНоменклатуры",
					СтрокаРаспределения.НомерСтроки, "КассаККМ");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, КонтекстноеПоле, , Отказ);
			КонецЕсли;
			
			Если МассивКассККМРаспределения.Найти(СтрокаРаспределения.КассаККМ) = Неопределено Тогда
				МассивКассККМРаспределения.Добавить(СтрокаРаспределения.КассаККМ);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет табличную часть КнопкиНижнейПанели по данным макета СтандартныеДействияКнопокНижнейПанели
//
Процедура ЗаполнитьТаблицуКнопокИзМакета() Экспорт

	Макет = Справочники.НастройкиРМК.ПолучитьМакет("СтандартныеДействияКнопокНижнейПанели");
	
	КолСтрок = Макет.ВысотаТаблицы;
	
	Для НомерСтрокиМакета = 2 По КолСтрок Цикл
		
		СтрокаТаблицы = Новый Структура;
		
		СтрокаТаблицы.Вставить("ПредставлениеКнопки", Макет.Область(НомерСтрокиМакета,1,НомерСтрокиМакета,1).Текст);
		СтрокаТаблицы.Вставить("ИмяКоманды", Макет.Область(НомерСтрокиМакета,2,НомерСтрокиМакета,2).Текст);
		СтрокаТаблицы.Вставить("ИмяКнопки", Макет.Область(НомерСтрокиМакета,3,НомерСтрокиМакета,3).Текст);
		СтрокаТаблицы.Вставить("ЗаголовокКнопки", Макет.Область(НомерСтрокиМакета,4,НомерСтрокиМакета,4).Текст);
		СтрокаТаблицы.Вставить("Клавиша", Макет.Область(НомерСтрокиМакета,6,НомерСтрокиМакета,6).Текст);
		СтрокаТаблицы.Вставить("Alt", Булево(Макет.Область(НомерСтрокиМакета,7,НомерСтрокиМакета,7).Текст));
		СтрокаТаблицы.Вставить("Ctrl", Булево(Макет.Область(НомерСтрокиМакета,8,НомерСтрокиМакета,8).Текст));
		СтрокаТаблицы.Вставить("Shift", Булево(Макет.Область(НомерСтрокиМакета,9,НомерСтрокиМакета,9).Текст));
		СтрокаТаблицы.Вставить("ПоУмолчанию", Булево(Макет.Область(НомерСтрокиМакета,10,НомерСтрокиМакета,10).Текст));
		
		ТекущиеДанные = КнопкиНижнейПанели.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, СтрокаТаблицы);
		
		ТекущиеДанные.СочетаниеКлавиш = ПредставлениеСочетанияКлавишПоЭлементам(ТекущиеДанные.Клавиша, ТекущиеДанные.Alt, ТекущиеДанные.Ctrl, ТекущиеДанные.Shift, Истина);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьТаблицуКнопокИзМакета()

// Функция возвращает представление сочетания клавиш по отдельным элементам этого сочетания
//
// Параметры:
//  Клавиша - клавиша
//  Alt - Булево - нажата клавиша Alt
//  Ctrl - Булево - нажата клавиша Alt
//  Shift - Булево - нажата клавиша Alt
//  БезСкобок - Булево - если Истина, то возвращаемое значение заключает в круглые скобки
//
// Возвращаемое значение
//	Строка - Представление клавиши
//
Функция ПредставлениеСочетанияКлавишПоЭлементам(Клавиша, Alt, Ctrl, Shift, БезСкобок = Ложь) Экспорт
	
	Если Клавиша = "" Тогда
		Возврат "";
	КонецЕсли;
	
	ПредставлениеСочетанияКлавиш = ?(БезСкобок, "", "(");
	Если Ctrl Тогда
		ПредставлениеСочетанияКлавиш = ПредставлениеСочетанияКлавиш + "Ctrl+"
	КонецЕсли;
	Если Alt Тогда
		ПредставлениеСочетанияКлавиш = ПредставлениеСочетанияКлавиш + "Alt+"
	КонецЕсли;
	Если Shift Тогда
		ПредставлениеСочетанияКлавиш = ПредставлениеСочетанияКлавиш + "Shift+"
	КонецЕсли;
	ПредставлениеСочетанияКлавиш = ПредставлениеСочетанияКлавиш + ПредставлениеКлавиши(Клавиша) + ?(БезСкобок, "", ")");
	
	Возврат ПредставлениеСочетанияКлавиш;
	
КонецФункции

// Функция возвращает представление клавиши
// Параметры:
//	ЗначениеКлавиша						- Клавиша
//
// Возвращаемое значение
//	Строка - Представление клавиши
//
Функция ПредставлениеКлавиши(ЗначениеКлавиша) Экспорт
	
	Если Строка(Клавиша._1) = Строка(ЗначениеКлавиша) Тогда
		Возврат "1";
	ИначеЕсли Строка(Клавиша._2) = Строка(ЗначениеКлавиша) Тогда
		Возврат "2";
	ИначеЕсли Строка(Клавиша._3) = Строка(ЗначениеКлавиша) Тогда
		Возврат "3";
	ИначеЕсли Строка(Клавиша._4) = Строка(ЗначениеКлавиша) Тогда
		Возврат "4";
	ИначеЕсли Строка(Клавиша._5) = Строка(ЗначениеКлавиша) Тогда
		Возврат "5";
	ИначеЕсли Строка(Клавиша._6) = Строка(ЗначениеКлавиша) Тогда
		Возврат "6";
	ИначеЕсли Строка(Клавиша._7) = Строка(ЗначениеКлавиша) Тогда
		Возврат "7";
	ИначеЕсли Строка(Клавиша._8) = Строка(ЗначениеКлавиша) Тогда
		Возврат "8";
	ИначеЕсли Строка(Клавиша._9) = Строка(ЗначениеКлавиша) Тогда
		Возврат "9";
	ИначеЕсли Строка(Клавиша.Num0) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 0";
	ИначеЕсли Строка(Клавиша.Num1) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 1";
	ИначеЕсли Строка(Клавиша.Num2) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 2";
	ИначеЕсли Строка(Клавиша.Num3) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 3";
	ИначеЕсли Строка(Клавиша.Num4) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 4";
	ИначеЕсли Строка(Клавиша.Num5) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 5";
	ИначеЕсли Строка(Клавиша.Num6) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 6";
	ИначеЕсли Строка(Клавиша.Num7) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 7";
	ИначеЕсли Строка(Клавиша.Num8) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 8";
	ИначеЕсли Строка(Клавиша.Num9) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num 9";
	ИначеЕсли Строка(Клавиша.NumAdd) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num +";
	ИначеЕсли Строка(Клавиша.NumDecimal) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num .";
	ИначеЕсли Строка(Клавиша.NumDivide) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num /";
	ИначеЕсли Строка(Клавиша.NumMultiply) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num *";
	ИначеЕсли Строка(Клавиша.NumSubtract) = Строка(ЗначениеКлавиша) Тогда
		Возврат "Num -";
	Иначе
		Возврат Строка(ЗначениеКлавиша);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// См. ЭлектроннаяПочтаУНФПереопределяемый.ПриСозданииСобытияНаОснованииИнтернетПочтовогоСообщения
//
Процедура ПриСозданииСобытияНаОснованииИнтернетПочтовогоСообщения(Событие, ИнтернетПочтовоеСообщение) Экспорт
	
	Если СтрНайти(Событие.Тема, "Заполнена форма") = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСобытиеПоДаннымКонтактнойФормы(Событие);
	
КонецПроцедуры

Процедура ЗаполнитьСобытиеПоДаннымКонтактнойФормы(Событие) Экспорт
	
	ТемаИСодержание = Событие.ДополнительныеСвойства.ТемаИСодержание;
	ИндексИдентификатораФормы = СтрНайти(Событие.ДополнительныеСвойства.ТемаИСодержание,"formId:");
	
	Если ИндексИдентификатораФормы = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторФормы = СокрЛП(Сред(ТемаИСодержание,ИндексИдентификатораФормы + 7, СтрНайти(ТемаИСодержание,";") - (ИндексИдентификатораФормы + 7)));
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтактныеФормыGoogleПоляКонструктора.Ссылка КАК Ссылка,
	|	КонтактныеФормыGoogleПоляКонструктора.Заголовок КАК Заголовок,
	|	КонтактныеФормыGoogleПоляКонструктора.ПолеПоискаУНФ КАК ПолеПоискаУНФ
	|ИЗ
	|	Справочник.КонтактныеФормыGoogle.ПоляКонструктора КАК КонтактныеФормыGoogleПоляКонструктора
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеФормыGoogle КАК КонтактныеФормыGoogle
	|		ПО (КонтактныеФормыGoogleПоляКонструктора.Ссылка = КонтактныеФормыGoogle.Ссылка)
	|ГДЕ
	|	КонтактныеФормыGoogleПоляКонструктора.ПолеПоискаУНФ <> ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.ПустаяСсылка)
	|	И КонтактныеФормыGoogle.ИдентификаторФормы ПОДОБНО &Идентификатор
	|	И НЕ КонтактныеФормыGoogle.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Идентификатор", ИдентификаторФормы);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	КИИзСодержанияСобытия = ЗаполнитьКИПоСодержанию(Выборка, ТемаИСодержание);
	Если НЕ ЗаполнитьУчастниковСобытияКонтрагентКонтакт(Событие, КИИзСодержанияСобытия) Тогда
		ЗаполнитьУчастниковСобытияЛиды(Событие, КИИзСодержанияСобытия)
	КонецЕсли;
	
КонецПроцедуры

Функция ПодготовитьКонтактнуюИнформациюПоДаннымКФ(Событие, КакСвязаться) Экспорт
	
	Если СтрНайти(Событие.Содержание,КакСвязаться)= 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИндексИдентификатораФормы = СтрНайти(Событие.Содержание,"formId:");
	
	Если ИндексИдентификатораФормы = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИдентификаторФормы = СокрЛП(Сред(Событие.Содержание,ИндексИдентификатораФормы + 7, СтрНайти(Событие.Содержание,";") - (ИндексИдентификатораФормы + 7)));
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтактныеФормыGoogleПоляКонструктора.Ссылка КАК Ссылка,
	|	КонтактныеФормыGoogleПоляКонструктора.Заголовок КАК Заголовок,
	|	КонтактныеФормыGoogleПоляКонструктора.ПолеПоискаУНФ КАК ПолеПоискаУНФ
	|ИЗ
	|	Справочник.КонтактныеФормыGoogle.ПоляКонструктора КАК КонтактныеФормыGoogleПоляКонструктора
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеФормыGoogle КАК КонтактныеФормыGoogle
	|		ПО КонтактныеФормыGoogleПоляКонструктора.Ссылка = КонтактныеФормыGoogle.Ссылка
	|ГДЕ
	|	КонтактныеФормыGoogleПоляКонструктора.ПолеПоискаУНФ <> ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.ПустаяСсылка)
	|	И КонтактныеФормыGoogle.ИдентификаторФормы ПОДОБНО &Идентификатор
	|	И НЕ КонтактныеФормыGoogle.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Идентификатор", ИдентификаторФормы);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	КИИзСодержанияСобытия = ЗаполнитьКИПоСодержанию(Выборка, Событие.Содержание);
	
	Возврат КИИзСодержанияСобытия;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗаполнитьКИПоСодержанию(Выборка, Содержание)
	
	МассивТелефонов = Новый Массив;
	МассивСкайп     = Новый Массив;
	МассивАдресовЭП = Новый Массив;
	МассивКИДругое  = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		ИндексОтвета = СтрНайти(Содержание, Выборка.Заголовок);
		Если ИндексОтвета = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НачалоОтвета = ИндексОтвета + СтрДлина(Выборка.Заголовок) + 1;
		ДлинаОтвета  = СтрНайти(Содержание,";",,НачалоОтвета) - НачалоОтвета;
		Ответ = СокрЛП(Сред(Содержание, НачалоОтвета, ДлинаОтвета));
		
		Если НЕ ЗначениеЗаполнено(Ответ) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Выборка.ПолеПоискаУНФ = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
			МассивАдресовЭП.Добавить(Ответ);
		ИначеЕсли Выборка.ПолеПоискаУНФ = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
			ПредставлениеКИ = КонтактнаяИнформацияУНФ.ПреобразоватьНомерДляКонтактнойИнформации(Ответ);
			ПредставлениеКИ = СтрЗаменить(ПредставлениеКИ, "+", "");
			МассивТелефонов.Добавить(Ответ);
			МассивТелефонов.Добавить(ПредставлениеКИ);
			Если Лев(ПредставлениеКИ, 2) = "79" Тогда
				ПредставлениеКИ = "8"+Сред(ПредставлениеКИ, 2);
			КонецЕсли;
			МассивТелефонов.Добавить(ПредставлениеКИ);
		ИначеЕсли Выборка.ПолеПоискаУНФ = Перечисления.ТипыКонтактнойИнформации.Skype Тогда
			МассивСкайп.Добавить(Ответ);
		Иначе
			МассивКИДругое.Добавить(Ответ);
		КонецЕсли;
		
	КонецЦикла;
	
	КИПоСодержанию = Новый Соответствие;
	КИПоСодержанию.Вставить("АдресаЭП", МассивАдресовЭП);
	КИПоСодержанию.Вставить("Скайп", МассивСкайп);
	КИПоСодержанию.Вставить("НомераТелефонов", МассивТелефонов);
	КИПоСодержанию.Вставить("Другое", МассивКИДругое);
	Возврат КИПоСодержанию;
	
КонецФункции

Функция ЗаполнитьУчастниковСобытияКонтрагентКонтакт(Событие, КИИзСодержанияСобытия)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтрагентыКонтактнаяИнформация.Ссылка КАК Контакт,
	|	КонтрагентыКонтактнаяИнформация.АдресЭП КАК АдресЭП
	|ИЗ
	|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
	|ГДЕ
	|	(&ИскатьВЭП
	|				И КонтрагентыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	|				И КонтрагентыКонтактнаяИнформация.АдресЭП В (&АдресаЭП)
	|			ИЛИ &ИскатьВСкайп
	|				И КонтрагентыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Skype)
	|				И КонтрагентыКонтактнаяИнформация.Представление В (&Скайп)
	|			ИЛИ &ИскатьВНомерах
	|				И КонтрагентыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	|				И КонтрагентыКонтактнаяИнформация.НомерТелефона В (&НомераТелефонов)
	|			ИЛИ &ИскатьВДругое
	|				И КонтрагентыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Другое)
	|				И КонтрагентыКонтактнаяИнформация.Представление В (&Другое))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КонтактыКонтактнаяИнформация.Ссылка,
	|	КонтактыКонтактнаяИнформация.АдресЭП
	|ИЗ
	|	Справочник.КонтактныеЛица.КонтактнаяИнформация КАК КонтактыКонтактнаяИнформация
	|ГДЕ
	|	(&ИскатьВЭП
	|				И КонтактыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	|				И КонтактыКонтактнаяИнформация.АдресЭП В (&АдресаЭП)
	|			ИЛИ &ИскатьВСкайп
	|				И КонтактыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Skype)
	|				И КонтактыКонтактнаяИнформация.Представление В (&Скайп)
	|			ИЛИ &ИскатьВНомерах
	|				И КонтактыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	|				И КонтактыКонтактнаяИнформация.НомерТелефона В (&НомераТелефонов)
	|			ИЛИ &ИскатьВДругое
	|				И КонтактыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Другое)
	|				И КонтактыКонтактнаяИнформация.Представление В (&Другое))";
	
	
	Запрос.УстановитьПараметр("ИскатьВЭП", КИИзСодержанияСобытия["АдресаЭП"].Количество()>0);
	Запрос.УстановитьПараметр("АдресаЭП", КИИзСодержанияСобытия["АдресаЭП"]);
	Запрос.УстановитьПараметр("ИскатьВСкайп", КИИзСодержанияСобытия["Скайп"].Количество()>0);
	Запрос.УстановитьПараметр("Скайп", КИИзСодержанияСобытия["Скайп"]);
	Запрос.УстановитьПараметр("ИскатьВНомерах", КИИзСодержанияСобытия["НомераТелефонов"].Количество()>0);
	Запрос.УстановитьПараметр("НомераТелефонов", КИИзСодержанияСобытия["НомераТелефонов"]);
	Запрос.УстановитьПараметр("ИскатьВДругое", КИИзСодержанияСобытия["Другое"].Количество()>0);
	Запрос.УстановитьПараметр("Другое", КИИзСодержанияСобытия["Другое"]);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ВыборкаАдресЭП = НРег(Выборка.АдресЭП);
		ДобавитьУчастникаСобытия(Событие, Выборка.Контакт, ВыборкаАдресЭП);
	КонецЦикла;	
	
	Возврат Истина;
	
КонецФункции

Процедура ЗаполнитьУчастниковСобытияЛиды(Событие, КИИзСодержанияСобытия)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЛидыКонтактнаяИнформация.Ссылка КАК Контакт,
	|	ЛидыКонтактнаяИнформация.АдресЭП КАК АдресЭП
	|ИЗ
	|	Справочник.Лиды.КонтактнаяИнформация КАК ЛидыКонтактнаяИнформация
	|ГДЕ
	|	(&ИскатьВЭП
	|				И ЛидыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	|				И ЛидыКонтактнаяИнформация.АдресЭП В (&АдресаЭП)
	|			ИЛИ &ИскатьВСкайп
	|				И ЛидыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Skype)
	|				И ЛидыКонтактнаяИнформация.Представление В (&Скайп)
	|			ИЛИ &ИскатьВНомерах
	|				И ЛидыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	|				И ЛидыКонтактнаяИнформация.НомерТелефона В (&НомераТелефонов)
	|			ИЛИ &ИскатьВДругое
	|				И ЛидыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Другое)
	|				И ЛидыКонтактнаяИнформация.Представление В (&Другое))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КонтактыЛидовКонтактнаяИнформация.Ссылка,
	|	КонтактыЛидовКонтактнаяИнформация.АдресЭП
	|ИЗ
	|	Справочник.КонтактыЛидов.КонтактнаяИнформация КАК КонтактыЛидовКонтактнаяИнформация
	|ГДЕ
	|	(&ИскатьВЭП
	|				И КонтактыЛидовКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	|				И КонтактыЛидовКонтактнаяИнформация.АдресЭП В (&АдресаЭП)
	|			ИЛИ &ИскатьВСкайп
	|				И КонтактыЛидовКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Skype)
	|				И КонтактыЛидовКонтактнаяИнформация.Представление В (&Скайп)
	|			ИЛИ &ИскатьВНомерах
	|				И КонтактыЛидовКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	|				И КонтактыЛидовКонтактнаяИнформация.НомерТелефона В (&НомераТелефонов)
	|			ИЛИ &ИскатьВДругое
	|				И КонтактыЛидовКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Другое)
	|				И КонтактыЛидовКонтактнаяИнформация.Представление В (&Другое))";
	
	
	Запрос.УстановитьПараметр("ИскатьВЭП", КИИзСодержанияСобытия["АдресаЭП"].Количество()>0);
	Запрос.УстановитьПараметр("АдресаЭП", КИИзСодержанияСобытия["АдресаЭП"]);
	Запрос.УстановитьПараметр("ИскатьВСкайп", КИИзСодержанияСобытия["Скайп"].Количество()>0);
	Запрос.УстановитьПараметр("Скайп", КИИзСодержанияСобытия["Скайп"]);
	Запрос.УстановитьПараметр("ИскатьВНомерах", КИИзСодержанияСобытия["НомераТелефонов"].Количество()>0);
	Запрос.УстановитьПараметр("НомераТелефонов", КИИзСодержанияСобытия["НомераТелефонов"]);
	Запрос.УстановитьПараметр("ИскатьВДругое", КИИзСодержанияСобытия["Другое"].Количество()>0);
	Запрос.УстановитьПараметр("Другое", КИИзСодержанияСобытия["Другое"]);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Если КИИзСодержанияСобытия["АдресаЭП"].Количество()>0 Тогда
			КИ = КИИзСодержанияСобытия["АдресаЭП"][0];
			ДобавитьУчастникаСобытия(Событие, КИ, КИ);
		ИначеЕсли  КИИзСодержанияСобытия["НомераТелефонов"].Количество()>0 Тогда
			КИ = КИИзСодержанияСобытия["НомераТелефонов"][0];
			ДобавитьУчастникаСобытия(Событие, КИ, "");
		ИначеЕсли КИИзСодержанияСобытия["Скайп"].Количество()>0 Тогда
			КИ = КИИзСодержанияСобытия["Скайп"][0];
			ДобавитьУчастникаСобытия(Событие, КИ, "");
		ИначеЕсли КИИзСодержанияСобытия["Другое"].Количество()>0 Тогда
			КИ = КИИзСодержанияСобытия["Другое"][0];
			ДобавитьУчастникаСобытия(Событие, КИ, "");
		Иначе
			Возврат;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ВыборкаАдресЭП = НРег(Выборка.АдресЭП);
		ДобавитьУчастникаСобытия(Событие, Выборка.Контакт, ВыборкаАдресЭП);
	КонецЦикла;	
	
КонецПроцедуры

Процедура ДобавитьУчастникаСобытия(Событие, Контакт, КакСвязаться)
	
	Если Событие.КонтактУжеЯвляетсяУчастником(Контакт) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Контакт) = Тип("СправочникСсылка.Контрагенты") ИЛИ ТипЗнч(Контакт) = Тип("Строка") Тогда
		НовыйУчастник = Событие.Участники.Вставить(0);
	Иначе
		НовыйУчастник = Событие.Участники.Добавить();
	КонецЕсли;
	
	НовыйУчастник.Контакт = ?(ЗначениеЗаполнено(Контакт), Контакт, КакСвязаться);
	НовыйУчастник.КакСвязаться = КакСвязаться;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
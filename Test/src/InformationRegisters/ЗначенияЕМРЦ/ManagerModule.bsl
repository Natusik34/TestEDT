#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
// Заполняет первоначальные значения ЕМРЦ для табачной продукции.
Процедура ЗаполнитьЗначенияРегистраЕМРЦ() Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		Блокировка = Новый БлокировкаДанных();
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗначенияЕМРЦ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("ОсобенностьУчета", Перечисления.ВидыМаркированнойПродукцииБПО.Табак);
		Блокировка.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.ЗначенияЕМРЦ.СоздатьНаборЗаписей();
		
		НоваяСтрока = НаборЗаписей.Добавить();
		НоваяСтрока.ОсобенностьУчета = Перечисления.ВидыМаркированнойПродукцииБПО.Табак; 
		НоваяСтрока.Период           = Дата('20230101');
		НоваяСтрока.Цена             = 0.02*3467*(1+0.2)*1.4;
		
		НоваяСтрока = НаборЗаписей.Добавить();
		НоваяСтрока.ОсобенностьУчета = Перечисления.ВидыМаркированнойПродукцииБПО.Табак; 
		НоваяСтрока.Период           = Дата('20230301');
		НоваяСтрока.Цена             = 0.02*3536*(1+0.2)*1.4;
		
		НоваяСтрока = НаборЗаписей.Добавить();
		НоваяСтрока.ОсобенностьУчета = Перечисления.ВидыМаркированнойПродукцииБПО.Табак; 
		НоваяСтрока.Период           = Дата('20240101');
		НоваяСтрока.Цена             = 0.02*3678*(1+0.2)*1.4;

		НоваяСтрока = НаборЗаписей.Добавить();
		НоваяСтрока.ОсобенностьУчета = Перечисления.ВидыМаркированнойПродукцииБПО.Табак; 
		НоваяСтрока.Период           = Дата('20250101');
		НоваяСтрока.Цена             = 0.02*3825*(1+0.2)*1.4;
		
		НаборЗаписей.Записать();
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ОбщегоНазначенияБПО.ЗаписатьОшибкуВЖурналРегистрации(
			НСтр("ru = 'Ошибка заполнения предопределенных элементов ЕМРЦ.'", ОбщегоНазначенияБПО.КодОсновногоЯзыка()));
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Получает цену ЕМРЦ из данных информационной базы на дату.
//
// Параметры:
//  ОсобенностьУчета - Перечисления.ВидыМаркированнойПродукцииБПО - тип маркированной продукции для проверки цены.
//  Период - Дата - дата проверки цены.
//  ЕМРЦ - Число - значение ЕМРЦ.
//
Процедура ПолучитьЦенуЕМРЦ(ОсобенностьУчета, Период = Неопределено, ЕМРЦ = 0) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НЕ ЗначениеЗаполнено(Период) Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗначенияЕМРЦСрезПоследних.Цена КАК Цена
	|ИЗ
	|	РегистрСведений.ЗначенияЕМРЦ.СрезПоследних(&Период, ОсобенностьУчета = &ОсобенностьУчета) КАК ЗначенияЕМРЦСрезПоследних";
	
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("ОсобенностьУчета", ОсобенностьУчета);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЕМРЦ = Выборка.Цена;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

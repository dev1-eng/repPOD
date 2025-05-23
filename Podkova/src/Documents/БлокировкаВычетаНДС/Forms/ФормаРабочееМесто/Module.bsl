#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("НачалоПериода") Тогда
		НачалоПериода = Параметры.НачалоПериода;
	Иначе
		НачалоПериода = НачалоМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	
	Если Параметры.Свойство("КонецПериода") Тогда
		КонецПериода = КонецМесяца(Параметры.КонецПериода);
	Иначе
		КонецПериода = КонецМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		Организация = Параметры.Организация;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьОтборыПоОрганизации();
	УстановитьОтборыПоПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_БлокировкаВычетаНДС" Тогда
		Если Параметр.РежимЗаписи = РежимЗаписиДокумента.Проведение ИЛИ Параметр.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
			Элементы.ЗаблокированныйНДС.Обновить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ОрганизацияСохраненноеЗначение <> Организация Тогда
		
		УстановитьОтборыПоПериоду();
		УстановитьОтборыПоОрганизации();
		ОрганизацияСохраненноеЗначение = Организация;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	УстановитьОтборыПоПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	УстановитьОтборыПоПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	УстановитьОтборыПоПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	УстановитьОтборыПоПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Элементы.ЗаблокированныйНДС.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаблокированныйНДС

&НаКлиенте
Процедура ЗаблокированныйНДСПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаблокированныйНДСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Элемент.ТекущиеДанные.СчетФактура);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументов

&НаКлиенте
Процедура СписокДокументовПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоПериода, КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", 
		ПараметрыВыбора, 
		Элементы.ВыбратьПериод, 
		, 
		, 
		, 
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура Добавить(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Организация", Организация);
	ЗначенияЗаполнения.Вставить("Состояние",   ПредопределенноеЗначение("Перечисление.СостоянияБлокировкиВычетаНДС.Установлена"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.БлокировкаВычетаНДС.ФормаОбъекта", ПараметрыФормы, ЭтаФорма, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Разблокировать(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Организация", Организация);
	ЗначенияЗаполнения.Вставить("Состояние",   ПредопределенноеЗначение("Перечисление.СостоянияБлокировкиВычетаНДС.Снята"));
	
	СчетаФактуры = Новый Массив;
	ВыбранныеСтроки = Элементы.ЗаблокированныйНДС.ВыделенныеСтроки;
	Для каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
		ДанныеСтроки = Элементы.ЗаблокированныйНДС.ДанныеСтроки(ВыбраннаяСтрока);
		СчетаФактуры.Добавить(ДанныеСтроки.СчетФактура);
		Если Не ЗначениеЗаполнено(Организация) Тогда
			ЗначенияЗаполнения.Организация = ДанныеСтроки.Организация;
		КонецЕсли;
	КонецЦикла;
	ЗначенияЗаполнения.Вставить("СчетаФактуры", СчетаФактуры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.БлокировкаВычетаНДС.ФормаОбъекта", ПараметрыФормы, ЭтаФорма, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Список = ?(Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗаблокированныйНДС,
		Элементы.ЗаблокированныйНДС, Элементы.СписокДокументов);
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	Список = ?(Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗаблокированныйНДС,
		Элементы.ЗаблокированныйНДС, Элементы.СписокДокументов);
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	Список = ?(Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаЗаблокированныйНДС,
		Элементы.ЗаблокированныйНДС, Элементы.СписокДокументов);
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборыПоОрганизации()
	
	СписокОрганизаций = Новый СписокЗначений;
	СписокОрганизаций.Добавить(Организация);
	
	Если ЗначениеЗаполнено(Организация)
		И ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс") Тогда
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ОбособленноеПодразделение
		|	И Организации.ГоловнаяОрганизация = &Организация
		|	И Организации.ДопускаютсяВзаиморасчетыЧерезГоловнуюОрганизацию");
		Запрос.УстановитьПараметр("Организация", Организация);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокОрганизаций.Добавить(Выборка.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ЗаблокированныйНДС,
		"Организация",
		СписокОрганизаций,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		ЗначениеЗаполнено(Организация));
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СписокДокументов,
		"Организация",
		СписокОрганизаций,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		ЗначениеЗаполнено(Организация));
		
	Элементы.ЗаблокированныйНДСОрганизация.Видимость = Не ЗначениеЗаполнено(Организация);
	Элементы.СписокДокументовОрганизация.Видимость = Не ЗначениеЗаполнено(Организация);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыПоПериоду()
	
	ГраницаКонецПериода = Новый Граница(КонецДня(КонецПериода), ВидГраницы.Включая);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ЗаблокированныйНДС,
		"КонецПериода",
		ГраницаКонецПериода);
	
	ГруппаЭлементовОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		СписокДокументов.Отбор.Элементы,
		Нстр("ru = 'Период'"),
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
		
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаЭлементовОтбора,
		"Дата",
		ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
		НачалоДня(НачалоПериода),
		Нстр("ru = 'Начало периода'"),
		ЗначениеЗаполнено(НачалоПериода));
		
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаЭлементовОтбора,
		"Дата",
		ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
		КонецДня(КонецПериода),
		Нстр("ru = 'Конец периода'"),
		ЗначениеЗаполнено(КонецПериода));
		
КонецПроцедуры


&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НачалоПериода = РезультатВыбора.НачалоПериода;
	КонецПериода = РезультатВыбора.КонецПериода;
	
	УстановитьОтборыПоПериоду();
	
КонецПроцедуры

#КонецОбласти
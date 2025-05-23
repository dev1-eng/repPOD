#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.ТорговыеПредложения
	ТорговыеПредложения.ПриСозданииПодсказокФормы(ЭтотОбъект, Элементы.ПодсказкиБизнесСеть);
	// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения
	
	КоммерческиеПредложенияДокументыПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	МетаданныеДокумента = КоммерческиеПредложенияСлужебный.МетаданныеПоОпределяемомуТипу("КоммерческоеПредложениеПоставщика");
	
	Элементы.ГруппаСмТакже.Видимость = МетаданныеДокумента <> Неопределено;
	
	Если Элементы.ГруппаСмТакже.Видимость Тогда
		
		СмТакже = МетаданныеДокумента.ПредставлениеСписка;
		ПолноеИмяФормы = "Документ." + МетаданныеДокумента.Имя + ".ФормаСписка";
		
		ПараметрыКоманды = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		ПараметрыКоманды.ТекстЗапроса =  ПолучитьТекстЗапроса(МетаданныеДокумента.Имя);
		
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, ПараметрыКоманды);
		Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	КонецЕсли;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	КоммерческиеПредложенияДокументыКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список,
	                                                                                       "Состояние",
	                                                                                       СостояниеОтбор,
	                                                                                       СтруктураБыстрогоОтбора,,
	                                                                                       ВидСравненияКомпоновкиДанных.ВСписке,
	                                                                                       "СостояниеОтбор");
	
	КоммерческиеПредложенияДокументыКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список,
	                                                                                       "Менеджер",
	                                                                                        Менеджер,
	                                                                                        СтруктураБыстрогоОтбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтправкаЗапросаКоммерческихПредложений"
			Или ИмяСобытия = "ОкончаниеСбораПредложений"
			Или ИмяСобытия = "ОтменаЗапросаКоммерческихПредложений" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	КоммерческиеПредложенияДокументыКлиентПереопределяемый.ОбработкаОповещенияФормСписка(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.ТорговыеПредложения
	ТорговыеПредложенияКлиент.ОбновитьПодсказкуФормы(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения

КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ПараметрыНастроек = КоммерческиеПредложенияДокументыКлиентСервер.ПараметрыОтбораПередЗагрузкойИзНастроек();
	ПараметрыНастроек.Список        = Список;
	ПараметрыНастроек.ИмяКолонки    = "Состояние";
	ПараметрыНастроек.ИмяНастройки  = "СостояниеОтбор";
	ПараметрыНастроек.Настройки     = Настройки;
	ПараметрыНастроек.Использование = Неопределено;
	ПараметрыНастроек.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	КоммерческиеПредложенияДокументыКлиентСервер.ОтборПоЗначениюСпискаПередЗагрузкойИзНастроек(ПараметрыНастроек, СостояниеОтбор, СтруктураБыстрогоОтбора);
	
	ПараметрыНастроек = КоммерческиеПредложенияДокументыКлиентСервер.ПараметрыОтбораПередЗагрузкойИзНастроек();
	ПараметрыНастроек.Список        = Список; 
	ПараметрыНастроек.ИмяКолонки    = "Менеджер";
	ПараметрыНастроек.ИмяНастройки  = "Менеджер";
	ПараметрыНастроек.Настройки     = Настройки;
	
	КоммерческиеПредложенияДокументыКлиентСервер.ОтборПоЗначениюСпискаПередЗагрузкойИзНастроек(ПараметрыНастроек, Менеджер, СтруктураБыстрогоОтбора);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
		"СрокОтработки", НачалоДня(ТекущаяДатаСеанса()), ВидСравненияКомпоновкиДанных.Меньше,,
		Настройки.Получить("Просрочен"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы


&НаКлиенте
Процедура ОтборСтатусНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	
	КоммерческиеПредложенияДокументыКлиент.МножественныйОтборСпискаНачалоВыбора(ЭтотОбъект,
	                                                                            Элемент,
	                                                                            СостояниеОтбор,
	                                                                            Тип("ПеречислениеСсылка.СостоянияЗапросаКоммерческихПредложений"),
	                                                                            НСтр("ru = 'Выбранные состояния'"));
	

КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	
	УстановитьОтборСостояние();
	
КонецПроцедуры

&НаКлиенте
Процедура ПросроченПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"СрокОтработки",
			НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса()),
			ВидСравненияКомпоновкиДанных.Меньше,
			,
			Просрочен);
			
	
КонецПроцедуры

&НаКлиенте
Процедура МенеджерПриИзменении(Элемент)
	
ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Менеджер",
	                                                                        Менеджер,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Менеджер));

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// ЭлектронноеВзаимодействие.ТорговыеПредложения
&НаКлиенте
Процедура Подключаемый_ПодсказкиБизнесСетьНажатие(Элемент)
	
	ТорговыеПредложенияКлиент.ОткрытьФормуПодсказок(ЭтотОбъект);
	
КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения

&НаСервереБезКонтекста
Функция ПолучитьТекстЗапроса(ИмяДокумента)

	Текст = 
		"ВЫБРАТЬ
		|	ДокументЗапросКоммерческихПредложенийПоставщиков.Ссылка КАК Ссылка,
		|	ДокументЗапросКоммерческихПредложенийПоставщиков.Дата КАК Дата,
		|	ДокументЗапросКоммерческихПредложенийПоставщиков.Номер КАК Номер,
		|	ДокументЗапросКоммерческихПредложенийПоставщиков.КраткоеОписание КАК Описание,
		|	ВЫБОР
		|		КОГДА СостоянияЗапросовКоммерческихПредложений.ТекущееСостояние ЕСТЬ NULL
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияЗапросаКоммерческихПредложений.Подготовка)
		|		КОГДА СостоянияЗапросовКоммерческихПредложений.ТекущееСостояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗапросаКоммерческихПредложений.СборПредложений)
		|				И &ТекущаяДата > ДокументЗапросКоммерческихПредложенийПоставщиков.ДатаОкончанияПубликации
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияЗапросаКоммерческихПредложений.АнализПредложений)
		|		ИНАЧЕ СостоянияЗапросовКоммерческихПредложений.ТекущееСостояние
		|	КОНЕЦ КАК Состояние,
		|	ВЫБОР
		|		КОГДА СостоянияЗапросовКоммерческихПредложений.ТекущееСостояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗапросаКоммерческихПредложений.Подготовка)
		|				ИЛИ СостоянияЗапросовКоммерческихПредложений.ТекущееСостояние ЕСТЬ NULL
		|			ТОГДА ДокументЗапросКоммерческихПредложенийПоставщиков.ДатаНачалаПубликации
		|		КОГДА СостоянияЗапросовКоммерческихПредложений.ТекущееСостояние = ЗНАЧЕНИЕ(Перечисление.СостоянияЗапросаКоммерческихПредложений.СборПредложений)
		|				И &ТекущаяДата < ДокументЗапросКоммерческихПредложенийПоставщиков.ДатаОкончанияПубликации
		|			ТОГДА ДокументЗапросКоммерческихПредложенийПоставщиков.ДатаОкончанияПубликации
		|		ИНАЧЕ ДокументЗапросКоммерческихПредложенийПоставщиков.ДатаОкончанияРассмотрения
		|	КОНЕЦ КАК СрокОтработки,
		|	ДокументЗапросКоммерческихПредложенийПоставщиков.ЗапрашиватьПредложенияПоставщиков = 0 КАК ПубликоватьВСервисе,
		|	ДокументЗапросКоммерческихПредложенийПоставщиков.Валюта КАК Валюта,
		|	ДокументЗапросКоммерческихПредложенийПоставщиков.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
		|	ДокументЗапросКоммерческихПредложенийПоставщиков.Организация КАК Организация,
		|	ДокументЗапросКоммерческихПредложенийПоставщиков.Менеджер КАК Менеджер,
		|	ЕСТЬNULL(ВложенныйЗапрос.ЕстьПредложения, ЛОЖЬ) КАК ЕстьПредложения
		|ИЗ
		|	Документ.ЗапросКоммерческихПредложенийПоставщиков КАК ДокументЗапросКоммерческихПредложенийПоставщиков
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияЗапросовКоммерческихПредложений КАК СостоянияЗапросовКоммерческихПредложений
		|		ПО ДокументЗапросКоммерческихПредложенийПоставщиков.Ссылка = СостоянияЗапросовКоммерческихПредложений.ЗапросКоммерческихПредложений
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			КоммерческиеПредложенияПоЗапросам.ЗапросКоммерческихПредложений КАК ЗапросКоммерческихПредложений,
		|			МАКСИМУМ(НЕ КоммерческиеПредложенияПоЗапросам.КоммерческоеПредложениеПоставщика ЕСТЬ NULL) КАК ЕстьПредложения
		|		ИЗ
		|			РегистрСведений.КоммерческиеПредложенияПоЗапросам КАК КоммерческиеПредложенияПоЗапросам
		|		
		|		СГРУППИРОВАТЬ ПО
		|			КоммерческиеПредложенияПоЗапросам.ЗапросКоммерческихПредложений) КАК ВложенныйЗапрос
		|		ПО ДокументЗапросКоммерческихПредложенийПоставщиков.Ссылка = ВложенныйЗапрос.ЗапросКоммерческихПредложений";
	
	Возврат СтрЗаменить(Текст, "КоммерческоеПредложениеПоставщика", ИмяДокумента);

КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	Список.УсловноеОформление.Элементы.Очистить();
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СрокОтработки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = ТекущаяДатаСеанса();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("СрокОтработки");
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЕстьПредложения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ЕстьПредложения");
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////

	КоммерческиеПредложенияДокументыПереопределяемый.ПриУстановкеУсловногоОформления(ЭтотОбъект);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

#Область БыстрыеОтборы

&НаКлиенте
Процедура ФормаМножественногоОтбораПослеЗакрытия(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеПараметры.Свойство("Элемент") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ДополнительныеПараметры.Элемент = Элементы.ОтборСтатус Тогда
		
		СостояниеОтбор = Результат;
		УстановитьОтборСостояние();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСостояние()

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Состояние",
	                                                                        СостояниеОтбор,
	                                                                        ВидСравненияКомпоновкиДанных.ВСписке,
	                                                                        ,
	                                                                        СостояниеОтбор.Количество() > 0);
	

КонецПроцедуры

&НаКлиенте
Процедура СмТакжеНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму(ПолноеИмяФормы);
КонецПроцедуры

#КонецОбласти

#КонецОбласти
#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереСписокДокументов(Список);
	// Конец ИнтернетПоддержкаПользователей.РаботаСКонтрагентами
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.КомандыЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(ПараметрыПриСозданииНаСервере);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// ЭлектронноеВзаимодействие.ТорговыеПредложения
	ТорговыеПредложения.ПриСозданииПодсказокФормы(ЭтотОбъект, Элементы.ПодсказкиБизнесСеть);
	// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения
	
	// ЭлектронноеВзаимодействие.БизнесСеть
	БизнесСеть.ПодключитьОповещениеОНовыхДокументахВСервисе(ЭтотОбъект, 
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Перечисления.ВидыЭД.ЗапросКоммерческихПредложений),
		Элементы.ГруппаПодобратьИзСервиса);
	// Конец ЭлектронноеВзаимодействие.БизнесСеть
	
	КоммерческиеПредложенияДокументыПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	МетаданныеДокумента = КоммерческиеПредложенияСлужебный.МетаданныеПоОпределяемомуТипу("КоммерческоеПредложениеКлиенту");
	
	Элементы.ГруппаСмТакже.Видимость   = МетаданныеДокумента <> Неопределено;
	
	Если Элементы.ГруппаСмТакже.Видимость Тогда
		
		Элементы.ДекорацияСсылка.Заголовок = МетаданныеДокумента.ПредставлениеСписка;
		ПолноеИмяФормы = "Документ." + МетаданныеДокумента.Имя + ".ФормаСписка";
		
		ПараметрыКоманды = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		ПараметрыКоманды.ТекстЗапроса =  ПолучитьТекстЗапроса(МетаданныеДокумента.Имя);
		
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, ПараметрыКоманды);
		
	КонецЕсли;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список,
	                                                                   "ДатаАктуальности",
	                                                                   ТекущаяДатаСеанса(),
	                                                                   Истина);
	
	КоммерческиеПредложенияДокументыКлиентСервер.ЗаполнитьСписокВыбораОтбораПоАктуальности(Элементы.ОтборСрокПодачиПредложения.СписокВыбора);
	
	КоммерческиеПредложенияДокументыКлиентСервер.ОтборПоАктуальностиПриСозданииНаСервере(Список, Актуальность, ДатаСобытия, 
	                                                                                     ТекущаяДатаСеанса(), СтруктураБыстрогоОтбора, 
	                                                                                     Элементы.ОтборСрокПодачиПредложения.СписокВыбора);
	
	КоммерческиеПредложенияДокументыКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список,
	                                                                                       "Менеджер",
	                                                                                        Менеджер,
	                                                                                        СтруктураБыстрогоОтбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// ЭлектронноеВзаимодействие.БизнесСеть
	БизнесСетьКлиент.ОбновитьИнформациюОНовыхДокументахВСервисе(ЭтотОбъект, ИмяСобытия);
	// Конец ЭлектронноеВзаимодействие.БизнесСеть
	
	КоммерческиеПредложенияДокументыКлиентПереопределяемый.ОбработкаОповещенияФормСписка(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// ЭлектронноеВзаимодействие.ТорговыеПредложения
	ТорговыеПредложенияКлиент.ОбновитьПодсказкуФормы(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения
	
	// ЭлектронноеВзаимодействие.БизнесСеть
	БизнесСетьКлиент.ОбновитьИнформациюОНовыхДокументахВСервисе(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.БизнесСеть
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ПараметрыНастроек = КоммерческиеПредложенияДокументыКлиентСервер.ПараметрыОтбораПередЗагрузкойИзНастроек();
	ПараметрыНастроек.Список        = Список; 
	ПараметрыНастроек.ИмяКолонки    = "Менеджер";
	ПараметрыНастроек.ИмяНастройки  = "Менеджер";
	ПараметрыНастроек.Настройки     = Настройки;
	
	КоммерческиеПредложенияДокументыКлиентСервер.ОтборПоЗначениюСпискаПередЗагрузкойИзНастроек(ПараметрыНастроек, Менеджер, СтруктураБыстрогоОтбора);

	ПараметрыНастроек = КоммерческиеПредложенияДокументыКлиентСервер.ПараметрыОтбораПередЗагрузкойИзНастроек();
	ПараметрыНастроек.Список        = Список;
	ПараметрыНастроек.ИмяКолонки    = "Предложения";
	ПараметрыНастроек.ИмяНастройки  = "ПредложенияБулево";
	ПараметрыНастроек.Настройки     = Настройки;
	ПараметрыНастроек.Использование = Не ПустаяСтрока(Настройки.Получить("Предложения"));
	
	КоммерческиеПредложенияДокументыКлиентСервер.ОтборПоЗначениюСпискаПередЗагрузкойИзНастроек(ПараметрыНастроек, ПредложенияБулево, СтруктураБыстрогоОтбора);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	КоммерческиеПредложенияДокументыКлиентСервер.ОтборПоАктуальностиПриЗагрузкеИзНастроек(
		Список,
		Актуальность,
		ДатаСобытия,
		ТекущаяДатаСеанса(),
		СтруктураБыстрогоОтбора,
		Настройки,
		Элементы.ОтборСрокПодачиПредложения.СписокВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияСсылкаНажатие(Элемент)
	ОткрытьФорму(ПолноеИмяФормы);
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокПодачиПредложенияПриИзменении(Элемент)
	
	КоммерческиеПредложенияДокументыКлиентСервер.ПриИзмененииОтбораПоАктуальности(
		Список, 
		Актуальность, 
		ДатаСобытия, 
		ОбщегоНазначенияКлиент.ДатаСеанса(),
		Элементы.ОтборСрокПодачиПредложения.СписокВыбора);

КонецПроцедуры

&НаКлиенте
Процедура ОтборПредложенияПриИзменении(Элемент)
	
	ПредложенияБулево = Ложь;
	Если ЗначениеЗаполнено(Предложения)
			И Булево(Предложения) Тогда
			
			ПредложенияБулево = Истина;
			
	КонецЕсли;
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"Предложения",
			ПредложенияБулево,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			ЗначениеЗаполнено(Предложения));
			
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборМенеджерПриИзменении(Элемент)
	
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

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

// ЭлектронноеВзаимодействие.БизнесСеть
&НаКлиенте
Процедура Подключаемый_ПодобратьДокументыИзСервисаБизнесСеть(Команда)
	
	БизнесСетьКлиент.ПодобратьДокументыИзСервисаБизнесСеть(ЭтотОбъект);
	
КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.БизнесСеть

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// ЭлектронноеВзаимодействие.ТорговыеПредложения
&НаКлиенте
Процедура Подключаемый_ПодсказкиБизнесСетьНажатие(Элемент)
	
	ТорговыеПредложенияКлиент.ОткрытьФормуПодсказок(ЭтотОбъект);
	
КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения

// ЭлектронноеВзаимодействие.БизнесСеть
&НаКлиенте
Процедура ОбновитьИнформациюОНовыхДокументахВСервисе()
	
	БизнесСетьКлиент.ОбновитьИнформациюОНовыхДокументахВСервисе(ЭтотОбъект);
	
КонецПроцедуры
// Конец ЭлектронноеВзаимодействие.БизнесСеть

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	Список.УсловноеОформление.Элементы.Очистить();
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтветитьДо");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = ТекущаяДатаСеанса();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ОтветитьДо");
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Предложения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Предложения");
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////

	КоммерческиеПредложенияДокументыПереопределяемый.ПриУстановкеУсловногоОформления(ЭтотОбъект);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокПодачиПредложенияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	КоммерческиеПредложенияДокументыКлиент.ПриВыбореОтбораПоАктуальности(
		ВыбранноеЗначение, 
		СтандартнаяОбработка, 
		ЭтаФорма,
		Список, 
		"Актуальность", 
		"ДатаСобытия",
		"ОтборСрокПодачиПредложения");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТекстЗапроса(ИмяДокумента)

	Текст = 
		"ВЫБРАТЬ
		|	ЗапросКоммерческогоПредложенияОтКлиента.Дата КАК Дата,
		|	ЗапросКоммерческогоПредложенияОтКлиента.Номер КАК Номер,
		|	ЗапросКоммерческогоПредложенияОтКлиента.Клиент КАК Покупатель,
		|	ЗапросКоммерческогоПредложенияОтКлиента.Контрагент КАК Контрагент,
		|	ЗапросКоммерческогоПредложенияОтКлиента.ХозяйственнаяОперация КАК Операция,
		|	ЗапросКоммерческогоПредложенияОтКлиента.ДатаОкончанияПубликации КАК ДатаСобытия,
		|	ЗапросКоммерческогоПредложенияОтКлиента.Валюта КАК Валюта,
		|	ЗапросКоммерческогоПредложенияОтКлиента.Организация КАК Организация,
		|	ВЫБОР
		|		КОГДА ДокументыСОшибкамиПроверкиКонтрагентов.Документ ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК СодержитНекорректныхКонтрагентов,
		|	ЗапросКоммерческогоПредложенияОтКлиента.Ссылка КАК Ссылка,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ КоммерческоеПредложениеКлиенту.Ссылка) > 0 КАК Предложения,
		|	ВЫБОР
		|		КОГДА ЗапросКоммерческогоПредложенияОтКлиента.ДатаОкончанияПубликации < &ДатаАктуальности
		|				И ЗапросКоммерческогоПредложенияОтКлиента.ДатаОкончанияПубликации <> ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Истек
		|ИЗ
		|	Документ.ЗапросКоммерческогоПредложенияОтКлиента КАК ЗапросКоммерческогоПредложенияОтКлиента
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыСОшибкамиПроверкиКонтрагентов КАК ДокументыСОшибкамиПроверкиКонтрагентов
		|		ПО ЗапросКоммерческогоПредложенияОтКлиента.Ссылка = ДокументыСОшибкамиПроверкиКонтрагентов.Документ
		|			И (&ИспользованиеПроверкиВозможно)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.КоммерческоеПредложениеКлиенту КАК КоммерческоеПредложениеКлиенту
		|		ПО ЗапросКоммерческогоПредложенияОтКлиента.Ссылка = КоммерческоеПредложениеКлиенту.ДокументОснование
		|			И (КоммерческоеПредложениеКлиенту.Проведен)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗапросКоммерческогоПредложенияОтКлиента.Ссылка,
		|	ВЫБОР
		|		КОГДА ДокументыСОшибкамиПроверкиКонтрагентов.Документ ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ,
		|	ЗапросКоммерческогоПредложенияОтКлиента.Дата,
		|	ЗапросКоммерческогоПредложенияОтКлиента.Номер,
		|	ЗапросКоммерческогоПредложенияОтКлиента.Клиент,
		|	ЗапросКоммерческогоПредложенияОтКлиента.Контрагент,
		|	ЗапросКоммерческогоПредложенияОтКлиента.ХозяйственнаяОперация,
		|	ЗапросКоммерческогоПредложенияОтКлиента.ДатаОкончанияПубликации,
		|	ЗапросКоммерческогоПредложенияОтКлиента.Валюта,
		|	ЗапросКоммерческогоПредложенияОтКлиента.Организация";
	
	Возврат СтрЗаменить(Текст, "КоммерческоеПредложениеКлиенту", ИмяДокумента);

КонецФункции

&НаКлиенте
Процедура ОтборСрокПодачиПредложенияОчистка(Элемент, СтандартнаяОбработка)
	
	КоммерческиеПредложенияДокументыКлиентСервер.ПриОчисткеОтбораПоАктуальности(
			Список,
			Актуальность, 
			ДатаСобытия, 
			ОбщегоНазначенияКлиент.ДатаСеанса(),
			СтандартнаяОбработка, 
			Элементы.ОтборСрокПодачиПредложения.СписокВыбора);
	

КонецПроцедуры

#КонецОбласти
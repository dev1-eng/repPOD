#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс


// Записывает данные документы в регистр сведений ДанныеВнутреннихДокументов
//
// Параметры:
//  Ссылка					 - ДокументСсылка - 
//  ДополнительныеСвойства	 - Структура - содержит по ключу ТаблицыДляДвижений структуру
//  										имеющую ключ ТаблицаРеестрДокументов (ТаблицаЗначений)
//  Отказ					 - Булево - 
//
Процедура ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ, ЭтоОбновлениеИБ = Ложь) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаРеестрДокументов = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеестрДокументов;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = РегистрыСведений.РеестрДокументов.СоздатьНаборЗаписей();
	Набор.Отбор.Ссылка.Установить(Ссылка);
	Набор.ЗагрузитьСОбработкой(ТаблицаРеестрДокументов);
	Если ЭтоОбновлениеИБ Тогда
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
	Иначе
		Набор.Записать();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	
КонецПроцедуры

// Записывает в регистр данные по переданному разделителю записи.
//
// Параметры:
//  РазделительЗаписи		 - ОпределяемыйТип.РазделительЗаписиРеестраДокументов - измерение, по которому необходимо выполнить запись. 
//  ДополнительныеСвойства	 - Структура - содержит по ключу ТаблицыДляДвижений структуру
//  	имеющую ключ ТаблицаРеестрДокументов (ТаблицаЗначений)
// ЗамещатьЗаписи			 - Булево - определяет режим замещения существующих записей разделителя. Истина - перед записью существующие
//		записи будут удалены. Ложь - записи будут дописаны к уже существующим в информационной базе записям.
//
Процедура ЗаписатьДанныеРазделителя(РазделительЗаписи, ДополнительныеСвойства, ЗамещатьЗаписи = Истина) Экспорт
	
	ТаблицаРеестрДокументов = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРеестрДокументов;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = РегистрыСведений.РеестрДокументов.СоздатьНаборЗаписей();
	Набор.Отбор.РазделительЗаписи.Установить(РазделительЗаписи);
	Набор.ЗагрузитьСОбработкой(ТаблицаРеестрДокументов);
	Набор.Записать(ЗамещатьЗаписи);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры


// Инициализирует и записывает данные документы в регистр сведений ДанныеВнутреннихДокументов.
//
// Параметры:
//  Ссылка				 - 	 - 
//
Процедура ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ, ЭтоОбновлениеИБ = Ложь) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Ссылка);
	МенеджерДокумента.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов");
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ, ЭтоОбновлениеИБ);
	
КонецПроцедуры

// Возвращает признак, того отражаются ли данные полученного объекта в реестре сведений или нет.
//
// Параметры:
//	ПроверяемыйОбъект - ДокументОбъект, ДокументСсылка, ДанныеФормыСтруктура, ОбъектМетаданных
//
// Возвращаемое значение
//	Булево - Истина, если данные полученного объекта, отражаются в реестре сведений.
//
Функция ОбъектВключенВСоставДанныхРеестра(ПроверяемыйОбъект) Экспорт
	
	ТипЗначения = ТипЗнч(ПроверяемыйОбъект);
	Если ТипЗначения = Тип("ДанныеФормыСтруктура") Тогда
		Если Не ПроверяемыйОбъект.Свойство("Ссылка") Тогда
			Возврат Ложь;
		КонецЕсли;
		ТипСсылки = ТипЗнч(ПроверяемыйОбъект.Ссылка);
	Иначе	
		Если ТипЗначения = Тип("ОбъектМетаданных") Тогда
			МетаданныеЗначения = ПроверяемыйОбъект;
		Иначе
			МетаданныеЗначения = Метаданные.НайтиПоТипу(ТипЗначения);
			
			Если МетаданныеЗначения = Неопределено Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Если Не ОбщегоНазначения.ЭтоДокумент(МетаданныеЗначения) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ТипСсылки = ТипЗнч(МетаданныеЗначения.СтандартныеРеквизиты.Ссылка.Тип.ПривестиЗначение());
	КонецЕсли;

	МетаданныеРегистра	= Метаданные.НайтиПоПолномуИмени("РегистрСведений.РеестрДокументов");
	Возврат МетаданныеРегистра.Измерения.Ссылка.Тип.СодержитТип(ТипСсылки);
	
КонецФункции

// Инициализирует и записывает данные документов, полученных объектов метаданных, в регистр сведений.
//
// Параметры:
//	ОбъектыМетаданных - Соответствие - объекты метаданных:
//		* Ключ		- ОбъектМетаданных: Документ	- объект метаданных документа.
//		* Значение	- Неопределено					- пустое значение.
//
Процедура ОтразитьДанныеДокументовВРеестре(ОбъектыМетаданных) Экспорт
	
	ИменаОбъектов		= Новый Массив;
	СсылкиДокументов	= Новый Массив;
	
	Для Каждого ЭлементДанных Из ОбъектыМетаданных Цикл
		ОбъектДанных		= ЭлементДанных.Ключ;
		ПолноеИмяОбъекта	= ОбъектДанных.ПолноеИмя();
		
		ИменаОбъектов.Добавить(ПолноеИмяОбъекта);
	КонецЦикла;
	
	НеиспользуемыеПоля = Новый Массив;
	НеиспользуемыеПоля.Добавить("Дополнительно");
	НеиспользуемыеПоля.Добавить("НомерПервичногоДокумента");
	
	Для Каждого ПолноеИмяОбъекта Из ИменаОбъектов Цикл
		
		ИмяДокумента = СтрРазделить(ПолноеИмяОбъекта, ".")[1];
		РезультатАдаптацииЗапроса = Документы[ИмяДокумента].АдаптированныйТекстЗапросаДвиженийПоРегистру("РеестрДокументов");
		Регистраторы = ОбновлениеИнформационнойБазыУТ.ДанныеНезависимогоРегистраДляПерепроведения(
							РезультатАдаптацииЗапроса,
							"РегистрСведений.РеестрДокументов",
							ПолноеИмяОбъекта,
							НеиспользуемыеПоля);
		
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СсылкиДокументов, Регистраторы.ВыгрузитьКолонку("Ссылка"));
		
	КонецЦикла;
	
	Для Каждого Ссылка Из СсылкиДокументов Цикл
		ДополнительныеСвойства = Новый Структура;
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Ложь);
	КонецЦикла;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ
	|	ЧтениеОбъектаРазрешено(Ссылка)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ИзменениеОбъектаРазрешено(Ссылка)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

#Область ОбработатьДанныеДляПереходаНаНовуюВерсию

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыСведений.РеестрДокументов.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.4.13.158";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("e1b07e2c-7c84-4d78-9e9a-0ae5bba90d97");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.РеестрДокументов.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.ЗапускатьИВПодчиненномУзлеРИБСФильтрами = Истина;
	Обработчик.Комментарий = НСтр("ru = 'Заполняет регистр ""Реестр документов"" по данным относящихся к нему документов (кроме счетов-фактур).'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.АвансовыйОтчет.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ТаможеннаяДекларацияИмпорт.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыСведений.РеестрДокументов.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыСведений.РеестрДокументов.ОбработатьДанныеДляПереходаНаНовуюВерсиюСФиВЭД";
	НоваяСтрока.Порядок = "До";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ТаможеннаяДекларацияИмпорт.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

#КонецОбласти

#Область ОбработатьДанныеДляПереходаНаНовуюВерсиюСФиВЭД

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыСведений.РеестрДокументов.ОбработатьДанныеДляПереходаНаНовуюВерсиюСФиВЭД";
	Обработчик.Версия = "11.4.9.9";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("cbe2a400-1232-4224-bc0c-fc673d2e49c7");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыСведений.РеестрДокументов.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсиюСФиВЭД";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.ЗапускатьИВПодчиненномУзлеРИБСФильтрами = Истина;
	Обработчик.Комментарий = НСтр("ru = 'Заполняет регистр ""Реестр документов"" по данным относящихся к нему документов (только счета-фактуры).'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.СчетФактураВыданный.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.СчетФактураКомиссионеру.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.СчетФактураКомитента.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.СчетФактураНалоговыйАгент.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.СчетФактураПолученный.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.СчетФактураПолученныйНалоговыйАгент.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыСведений.РеестрДокументов.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.СчетФактураВыданный.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.СчетФактураВыданный.ОбработатьДанныеДляПереходаНаНовуюВерсиюТовары";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.СчетФактураКомиссионеру.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.СчетФактураКомитента.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.СчетФактураНалоговыйАгент.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.СчетФактураПолученный.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.СчетФактураПолученныйНалоговыйАгент.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "РегистрыСведений.РеестрДокументов.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

#КонецОбласти

КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт 

	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = "РегистрСведений.РеестрДокументов";
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Ссылка.Дата УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Ссылка");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	ПараметрыВыборки.ИмяИзмеренияДляОтбора = "Ссылка";
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.Вставить("ЭтоНезависимыйРегистрСведений", Истина);
	ДополнительныеПараметры.Вставить("ПолноеИмяРегистра", "РегистрСведений.РеестрДокументов");
	
	ОбрабатываемыеТипыДокументов = Новый Массив;
	ОбрабатываемыеТипыДокументов.Добавить("Документ.АвансовыйОтчет");
	ОбрабатываемыеТипыДокументов.Добавить("Документ.ТаможеннаяДекларацияИмпорт");
	
	// Регистрация через АдаптированныйТекстЗапроса
	Для каждого ПолноеИмяДокумента Из ОбрабатываемыеТипыДокументов Цикл
		
		НеиспользуемыеПоля = Новый Массив;
		НеиспользуемыеПоля.Добавить("Дополнительно");
		НеиспользуемыеПоля.Добавить("РазделительЗаписи");
		НеиспользуемыеПоля.Добавить("НомерПервичногоДокумента");
		
		ИмяДокумента = СтрРазделить(ПолноеИмяДокумента, ".")[1];
		РезультатАдаптацииЗапроса = Документы[ИмяДокумента].АдаптированныйТекстЗапросаДвиженийПоРегистру("РеестрДокументов");
		Регистраторы = ОбновлениеИнформационнойБазыУТ.ДанныеНезависимогоРегистраДляПерепроведения(
							РезультатАдаптацииЗапроса, 
							"РегистрСведений.РеестрДокументов", 
							ПолноеИмяДокумента, 
							НеиспользуемыеПоля);
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Регистраторы, ДополнительныеПараметры);
		
	КонецЦикла;
	
	
	ПараметрыВыборки.ПолныеИменаОбъектов = СтрСоединить(ОбрабатываемыеТипыДокументов, ",");
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсиюСФиВЭД(Параметры) Экспорт 

	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = "РегистрСведений.РеестрДокументов";
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Ссылка.Дата УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Ссылка");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиРегистраторыРегистра();
	ПараметрыВыборки.ИмяИзмеренияДляОтбора = "Ссылка";
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.Вставить("ЭтоНезависимыйРегистрСведений", Истина);
	ДополнительныеПараметры.Вставить("ПолноеИмяРегистра", "РегистрСведений.РеестрДокументов");
	
	ОбрабатываемыеТипыДокументов = Новый Массив;
	ОбрабатываемыеТипыДокументов.Добавить("Документ.СчетФактураКомиссионеру");
	ОбрабатываемыеТипыДокументов.Добавить("Документ.СчетФактураКомитента");
	ОбрабатываемыеТипыДокументов.Добавить("Документ.СчетФактураНалоговыйАгент");
	ОбрабатываемыеТипыДокументов.Добавить("Документ.СчетФактураПолученныйНалоговыйАгент");
	
	// Регистрация через АдаптированныйТекстЗапроса
	Для каждого ПолноеИмяДокумента Из ОбрабатываемыеТипыДокументов Цикл
		
		НеиспользуемыеПоля = Новый Массив;
		НеиспользуемыеПоля.Добавить("Дополнительно");
		НеиспользуемыеПоля.Добавить("РазделительЗаписи");
		НеиспользуемыеПоля.Добавить("НомерПервичногоДокумента");
		
		ИмяДокумента = СтрРазделить(ПолноеИмяДокумента, ".")[1];
		РезультатАдаптацииЗапроса = Документы[ИмяДокумента].АдаптированныйТекстЗапросаДвиженийПоРегистру("РеестрДокументов");
		Регистраторы = ОбновлениеИнформационнойБазыУТ.ДанныеНезависимогоРегистраДляПерепроведения(
							РезультатАдаптацииЗапроса, 
							"РегистрСведений.РеестрДокументов", 
							ПолноеИмяДокумента, 
							НеиспользуемыеПоля);
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Регистраторы, ДополнительныеПараметры);
		
	КонецЦикла;
	
	// Счета-фактуры полученные и выданные регистрируем отдельно (не через адаптируемый текст запроса),
	// т.к. на момент регистрации разницы в документе и в регистре может не быть.
	ОбрабатываемыеТипыДокументов.Добавить("Документ.СчетФактураВыданный");
	ОбрабатываемыеТипыДокументов.Добавить("Документ.СчетФактураПолученный");
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РеестрДокументов.Ссылка КАК Ссылка
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|ГДЕ
	|	РеестрДокументов.ТипСсылки = &СчетФактураПолученный
	|	И НЕ РеестрДокументов.ДополнительнаяЗапись
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РеестрДокументов.Ссылка
	|ИЗ
	|	РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|ГДЕ
	|	РеестрДокументов.ТипСсылки = &СчетФактураВыданный
	|	И НЕ РеестрДокументов.ДополнительнаяЗапись";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СчетФактураВыданный", ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Документы.СчетФактураВыданный));
	Запрос.УстановитьПараметр("СчетФактураПолученный", ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Документы.СчетФактураПолученный));
	Регистраторы = Запрос.Выполнить().Выгрузить();
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Регистраторы, ДополнительныеПараметры);
	
	ПараметрыВыборки.ПолныеИменаОбъектов = СтрСоединить(ОбрабатываемыеТипыДокументов, ",");
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
		
	ВсеКлючиОбработаны = Истина;
	
	ОбъектыМетаданных = Справочники.КлючиРеестраДокументов.ОбъектыМетаданныхЗакешированныеВКлючахРеестра();
	ОбъектыМетаданных.Вставить(Метаданные.Справочники.КлючиРеестраДокументов);
	
	Для Каждого ОбъектМетаданных Из ОбъектыМетаданных Цикл
		ЕстьЗаблокированные = ОбновлениеИнформационнойБазы.ЕстьЗаблокированныеПредыдущимиОчередямиДанные(Параметры.Очередь,
			ОбъектМетаданных.Ключ.ПолноеИмя());
		Если ЕстьЗаблокированные Тогда
			ВсеКлючиОбработаны = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Если Не ВсеКлючиОбработаны Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазыУТ.ДополнительныеПараметрыПерезаписиДвиженийИзОчереди();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ИмяИзмеренияДляОтбора = "Ссылка";
	ДополнительныеПараметры.ЗаписыватьВОднойТранзакции = Ложь;
	ДополнительныеПараметры.НужнаДополнительнаяОбработкаЗаписей = Истина;
	ДополнительныеПараметры.ОбновляемыеДанные = Параметры.ОбновляемыеДанные;
	
	ВсеСделано = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(Неопределено,
																			"РегистрСведений.РеестрДокументов",
																			Параметры.Очередь,
																			ДополнительныеПараметры);
	
	Параметры.ОбработкаЗавершена = ВсеСделано;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсиюСФиВЭД(Параметры) Экспорт
	
	ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
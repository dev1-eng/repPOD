#Область СлужебныйПрограммныйИнтерфейс

#Область ИнициализацияТипаОбъектовФормата

Функция ТипОбъектаФормата(Знач ИмяОбъектаФормата) Экспорт
	
	Возврат ПреобразованиеДанныхEDIСлужебныйПовтИсп.ТипОбъектаФормата(ИмяОбъектаФормата,
		ПространствоИменФормата(АктуальныйФорматУниверсальногоОбменаДанными()));
		
КонецФункции

#КонецОбласти

#Область ПолучениеОбъектаФорматаПоСсылке

Функция ОбъектыФорматаПоСсылке(Знач Ссылка, ЕстьОшибки, ТекстОшибки = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КомпонентыОбмена = КомпонентыПреобразованияВОбъектФормата();
	
	// Заполнение параметров конвертации, описанных в правилах
	ВыполнитьОбработчикПередКонвертацией(КомпонентыОбмена, ЕстьОшибки, ТекстОшибки);
	Если ЕстьОшибки = Истина Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПравилоОбработки = ПравилоОбработкиОбъектаМетаданных(КомпонентыОбмена, Ссылка.Метаданные());
	Если Не ЗначениеЗаполнено(ПравилоОбработки) Тогда
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыОбмена,
			НСтр("ru = 'Поиск правила обработки данных'"),
			НСтр("ru = 'Не найдено правило для обработки объекта конфигурации.'"),
			Новый Структура("Объект", Ссылка.Метаданные().Имя));
		
		Возврат Неопределено;
	КонецЕсли;
	
	// Инициализация структуры данных результата конвертации
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("ОбъектФормата");
	Результат.Колонки.Добавить("ОбъектXDTO");
	
	Результат.Индексы.Добавить("ОбъектФормата");
	
	// Результат конвертации будет сохраняться в оперативную память для дальнейшей обработки
	Поток = Новый ПотокВПамяти;
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьПоток(Поток);
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьXML.ЗаписатьНачалоЭлемента("Body");
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("", КомпонентыОбмена.XMLСхема);
	
	КомпонентыОбмена.Вставить("ФайлОбмена", ЗаписьXML);

	Попытка
		ОбъектОбработки = Ссылка.ПолучитьОбъект();
		
		ОбменДаннымиXDTOСервер.ВыгрузкаОбъектаВыборки(КомпонентыОбмена, ОбъектОбработки, ПравилоОбработки);
	Исключение
		ЗаписьXML.Закрыть();
		Поток.Закрыть();
		
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыОбмена,
			НСтр("ru='Конвертация объекта ИБ'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
			Новый Структура("Объект", ПредставлениеОбъектаДляЖурнала(ОбъектОбработки)));
			
		Возврат Неопределено;
	КонецПопытки;
	
	КомпонентыОбмена.ФайлОбмена.ЗаписатьКонецЭлемента(); // Body

	ЗаписьXML.Закрыть();

	Если КомпонентыОбмена.ФлагОшибки Тогда
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыОбмена,
			НСтр("ru='Выгрузка объекта выборки'"),
			КомпонентыОбмена.СтрокаСообщенияОбОшибке,
			Новый Структура("Объект", ПредставлениеОбъектаДляЖурнала(ОбъектОбработки)));
			
		Поток.Закрыть();
		
		Возврат Неопределено;
	КонецЕсли;
	
	
	// Если результат пустой - это ошибка. Значит, для этого объекта ИБ нет правил конвертации.
	Если Поток.Размер() = 0 Тогда
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыОбмена,
			НСтр("ru='Выгрузка объекта выборки'"),
			НСтр("ru='Результат конвертации объекта информационной базы пуст.'"),
			Новый Структура("Объект", ПредставлениеОбъектаДляЖурнала(ОбъектОбработки)));
		
		Возврат Неопределено;
	КонецЕсли;
	
	
	// Преобразование результата конвертации в объекты XDTO
	Поток = Поток.ПолучитьПотокТолькоДляЧтения();
	Поток.Перейти(0, ПозицияВПотоке.Начало);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьПоток(Поток);
	ЧтениеXML.Прочитать(); // body
	
	ЧтениеXML.Прочитать();
	Пока ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Цикл
		ИмяОбъектаФормата = ЧтениеXML.ЛокальноеИмя;
		
		// Получаем из файла ОбъектXDTO.
		ТипОбъектаXDTO = ФабрикаXDTO.Тип(КомпонентыОбмена.XMLСхема, ИмяОбъектаФормата);
		ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ТипОбъектаXDTO);
		
		Если ТипОбъектаXDTO.Имя = "УдалениеОбъекта" Тогда
			Продолжить;
		КонецЕсли;

		НоваяЗапись = Результат.Добавить();
		НоваяЗапись.ОбъектФормата = ИмяОбъектаФормата;
		НоваяЗапись.ОбъектXDTO = ОбъектXDTO;
	КонецЦикла;
	
	ЧтениеXML.Закрыть();
	Поток.Закрыть();
	
	Результат.Свернуть("ОбъектФормата, ОбъектXDTO");
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат.Количество() = 0 Тогда
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыОбмена,
			НСтр("ru='Выгрузка объекта выборки'"),
			НСтр("ru='Результат конвертации объекта информационной базы пуст.'"),
			Новый Структура("Объект", ПредставлениеОбъектаДляЖурнала(ОбъектОбработки)));
		
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция КлючевыеСвойстваОбъектаФорматаПоСсылке(Знач Ссылка, Знач ОбъектФормата, ЕстьОшибки = Ложь, ТекстОшибки = "") Экспорт
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	КомпонентыОбмена = КомпонентыПреобразованияВОбъектФормата();
	
	// Заполнение параметров конвертации, описанных в правилах
	ВыполнитьОбработчикПередКонвертацией(КомпонентыОбмена, ЕстьОшибки, ТекстОшибки);
	Если ЕстьОшибки = Истина Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПравилоКонвертации = ПравилоКонвертации(КомпонентыОбмена, ОбъектФормата, Ссылка.Метаданные());
	Если ПравилоКонвертации = Неопределено Тогда
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыОбмена,
			НСтр("ru='Поиск правила конвертации'"),
			НСтр("ru = 'Не найдено правило для обработки из объекта конфигурации в объект формата.'"),
			Новый Структура("ОбъектКонфигурации, ОбъектФормата", Ссылка.Метаданные().Имя, ОбъектФормата));
		
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Неопределено;
	Попытка
		ОбъектОбработки = Ссылка.ПолучитьОбъект();
		
		ДанныеXDTO = ОбменДаннымиXDTOСервер.ДанныеXDTOИзДанныхИБ(КомпонентыОбмена, ОбъектОбработки, ПравилоКонвертации,
					ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка));
					
		Результат = ОбменДаннымиXDTOСервер.ОбъектXDTOИзДанныхXDTO(КомпонентыОбмена, ДанныеXDTO, ДанныеXDTO.ТипСоставногоСвойства);
	Исключение
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыОбмена,
			НСтр("ru='Конвертация объекта ИБ'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
			Новый Структура("Объект", ПредставлениеОбъектаДляЖурнала(ОбъектОбработки)));
		
		Возврат Неопределено;
	КонецПопытки;
	
	Если КомпонентыОбмена.ФлагОшибки Тогда
		ЕстьОшибки = Истина;
		ТекстОшибки = КомпонентыОбмена.СтрокаСообщенияОбОшибке;
		
		Возврат Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Результат, "КлючевыеСвойства") Тогда
		Результат = Результат.КлючевыеСвойства;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ЗаписьОбъектаФорматаВИнформационнуюБазу

Функция РезультатРасширеннойЗаписиОбъектаФормата(Знач ОбъектФормата, Знач ОбъектКонфигурации,
	Знач СопутствующиеСсылки = Неопределено, ЕстьОшибки = Ложь, ТекстОшибки = "") Экспорт
	
	КомпонентыВыгрузки = КомпонентыПреобразованияВОбъектФормата();
	
	// Результат конвертации будет сохраняться в оперативную память для дальнейшей обработки
	Поток = Новый ПотокВПамяти;
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьПоток(Поток);
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьXML.ЗаписатьНачалоЭлемента("Body");
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("", КомпонентыВыгрузки.XMLСхема);
	
	КомпонентыВыгрузки.Вставить("ФайлОбмена", ЗаписьXML);
	
	
	// формируем поток объектов XDTO для записи в ИБ
	Если СопутствующиеСсылки <> Неопределено Тогда
		Для Каждого СопутствующаяСсылка Из СопутствующиеСсылки Цикл
			ФабрикаXDTO.ЗаписатьXML(КомпонентыВыгрузки.ФайлОбмена, СопутствующаяСсылка.ОбъектФормата);
		КонецЦикла;
	КонецЕсли;
	
	ФабрикаXDTO.ЗаписатьXML(КомпонентыВыгрузки.ФайлОбмена, ОбъектФормата);
	
	КомпонентыВыгрузки.ФайлОбмена.ЗаписатьКонецЭлемента(); // Body

	ЗаписьXML.Закрыть();

	Если КомпонентыВыгрузки.ФлагОшибки Тогда
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыВыгрузки,
			НСтр("ru='Выгрузка объекта выборки'"),
			КомпонентыВыгрузки.СтрокаСообщенияОбОшибке);
			
		Поток.Закрыть();
		
		Возврат Неопределено;
	КонецЕсли;
	
	// Если результат пустой - это ошибка. Значит, для этого объекта ИБ нет правил конвертации.
	Если Поток.Размер() = 0 Тогда
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыВыгрузки,
			НСтр("ru='Выгрузка объекта выборки'"),
			НСтр("ru='Результат конвертации объекта информационной базы пуст.'"));
		
		Возврат Неопределено;
	КонецЕсли;
	
	
	КомпонентыЗагрузки = КомпонентыПреобразованияИзОбъектФормата();
	
	// Запись объектов XDTO в ИБ
	Поток = Поток.ПолучитьПотокТолькоДляЧтения();
	Поток.Перейти(0, ПозицияВПотоке.Начало);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьПоток(Поток);
	ЧтениеXML.Прочитать(); // body
	
	ЧтениеXML.Прочитать();
	КомпонентыЗагрузки.Вставить("ФайлОбмена", ЧтениеXML);
	
	УстановитьПривилегированныйРежим(Истина);
	ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Истина);
	Попытка
		ОбменДаннымиXDTOСервер.ПроизвестиЧтениеДанных(КомпонентыЗагрузки);
		ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Ложь);
	Исключение
		ОбменДаннымиСлужебный.ОтключитьОбновлениеКлючейДоступа(Ложь);
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыВыгрузки,
			НСтр("ru='Загрузка объектов'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	УстановитьПривилегированныйРежим(Ложь);
	
	Поток.Закрыть();
	
	Если КомпонентыЗагрузки.ФлагОшибки Тогда
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыВыгрузки,
			НСтр("ru='Загрузка объектов'"),
			КомпонентыВыгрузки.СтрокаСообщенияОбОшибке);
		
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Неопределено;
	ЗагруженныеОбъекты = КомпонентыЗагрузки.ЗагруженныеОбъекты.ВыгрузитьКолонку("СсылкаНаОбъект");
	Для Каждого ЗагруженныйОбъект Из ЗагруженныеОбъекты Цикл
		Если ЗагруженныйОбъект.Метаданные() = ОбъектКонфигурации Тогда
			Результат = ЗагруженныйОбъект;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Результат = Неопределено Тогда
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыВыгрузки,
			НСтр("ru='Загрузка объектов'"),
			НСтр("ru = 'Объект конфигурации не был создан из объекта формата.'"));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область РаботаСОбъектамиФормата

Функция ОбъектФорматаПоКлючевымСвойствам(Знач КлючевыеСвойстваXDTO, Знач ИмяОбъектаФормата, Знач ОбъектКонфигурации,
		ЕстьОшибки = Ложь, ТекстОшибки = "") Экспорт
	
	РежимЗагрузкиДанныхВИнформационнуюБазу = "ПолучитьСсылку";
	КомпонентыОбмена = КомпонентыПреобразованияИзОбъектФормата();
	
	ПравилоКонвертации = ПравилоКонвертации(КомпонентыОбмена, ИмяОбъектаФормата, ОбъектКонфигурации);
	Если ПравилоКонвертации = Неопределено Тогда
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыОбмена,
			НСтр("ru='Поиск правила конвертации'"),
			НСтр("ru = 'Не найдено правило конвертации из объекта формата в объект конфигурации.'"),
			Новый Структура("ОбъектКонфигурации, ОбъектФормата", ОбъектКонфигурации.Имя, ИмяОбъектаФормата));
		
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		ДанныеXDTO = ОбменДаннымиXDTOСервер.ОбъектXDTOВСтруктуру(КлючевыеСвойстваXDTO, КомпонентыОбмена);
		
		Ссылка = ОбменДаннымиXDTOСервер.СтруктураОбъектаXDTOВДанныеИБ(
			КомпонентыОбмена,
			ДанныеXDTO,
			ПравилоКонвертации,
			РежимЗагрузкиДанныхВИнформационнуюБазу);
	Исключение
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыОбмена,
			НСтр("ru='Объект XDTO в ссылку'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
			Новый Структура("ОбъектФормата, Правило",
				ПредставлениеОбъектаДляЖурнала(КлючевыеСвойстваXDTO), ПравилоКонвертации.ИмяПКО));
		
		Возврат Неопределено;
	КонецПопытки;
	
	Если КомпонентыОбмена.ФлагОшибки Или Ссылка = Неопределено Тогда
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыОбмена,
			НСтр("ru='Объект XDTO в ссылку'"),
			Новый Структура("ОбъектФормата, Правило",
				ПредставлениеОбъектаДляЖурнала(КлючевыеСвойстваXDTO), ПравилоКонвертации.ИмяПКО));
		
		Возврат Неопределено;
	КонецЕсли;
	
	РезультатыКонвертации = ОбъектыФорматаПоСсылке(Ссылка, ЕстьОшибки, ТекстОшибки);
	Если ЕстьОшибки Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РезультатКонвертации = РезультатыКонвертации.Найти(ИмяОбъектаФормата, "ОбъектФормата");
	Если РезультатКонвертации = Неопределено Тогда
		ЕстьОшибки = Истина;
		ТекстОшибки = СтрШаблон(НСтр("ru = 'Не удалось получить объект формата из %1.'"),
			ПредставлениеОбъектаДляЖурнала(Ссылка));
		Возврат Неопределено;
	КонецЕсли;

	Возврат РезультатКонвертации.ОбъектXDTO;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияКомпонентОбмена

Функция КомпонентыПреобразованияИзОбъектФормата()
	
	// Определение версии формата и пространства имен.
	ВерсияФормата = АктуальныйФорматУниверсальногоОбменаДанными();
	ПространствоИмен = ПространствоИменФормата(ВерсияФормата);
	
	// Инициализация структуры параметров и правил конвертации
	КомпонентыОбмена = КомпонентыОбмена(
		НаправлениеОбменаПолучение(), ПространствоИмен, ВерсияФормата);
		
	КомпонентыОбмена.ПравилаКонвертацииОбъектов.Индексы.Добавить("ИмяПКО, ОбъектДанных");
	КомпонентыОбмена.ПравилаКонвертацииОбъектов.Индексы.Добавить("ОбъектФормата, ОбъектДанных");
		
	Возврат КомпонентыОбмена;
	
КонецФункции

Функция КомпонентыПреобразованияВОбъектФормата()
	
	// Определение версии формата и пространства имен.
	ВерсияФормата = АктуальныйФорматУниверсальногоОбменаДанными();
	ПространствоИмен = ПространствоИменФормата(ВерсияФормата);
	
	// Инициализация структуры параметров и правил конвертации
	КомпонентыОбмена = КомпонентыОбмена(
		НаправлениеОбменаОтправка(), ПространствоИмен, ВерсияФормата);
		
	КомпонентыОбмена.ПравилаКонвертацииОбъектов.Индексы.Добавить("ИмяПКО, ОбъектДанных");
	КомпонентыОбмена.ПравилаКонвертацииОбъектов.Индексы.Добавить("ОбъектФормата, ОбъектДанных");
		
	Возврат КомпонентыОбмена;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийКонвертации

#Область Обработчики

Процедура ВыполнитьОбработчикПередКонвертацией(КомпонентыОбмена, ЕстьОшибки, ТекстОшибки)
	
	ЕстьОшибки = Ложь;
	
	Попытка
		КомпонентыОбмена.МенеджерОбмена.ПередКонвертацией(КомпонентыОбмена);
	Исключение
		ЕстьОшибки = Истина;
		ТекстОшибки = ОшибкаОбработчикаКонвертации(
			КомпонентыОбмена,
			НСтр("ru='Перед конвертацией'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Если КомпонентыОбмена.ФлагОшибки Тогда
		ЕстьОшибки = Истина;
		ТекстОшибки = КомпонентыОбмена.СтрокаСообщенияОбОшибке;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработкаИсключений

Функция ОшибкаОбработчикаКонвертации(КомпонентыОбмена, Знач ИмяОбработчика, Знач ТекстИсключения,
	Знач ПараметрыОбработчика = Неопределено)
	
	Если КомпонентыОбмена.НаправлениеОбмена = НаправлениеОбменаОтправка() Тогда
		ТекстНаправления = НСтр("ru = 'в объект формата'");
	Иначе
		ТекстНаправления = НСтр("ru = 'из объекта формата'");
	КонецЕсли;
	
	ПредставлениеОшибки = Новый Массив;
	ПредставлениеОшибки.Добавить(СтрШаблон(НСтр("ru = 'Ошибка конвертации %1.'"), ТекстНаправления));
	ПредставлениеОшибки.Добавить("");
	ПредставлениеОшибки.Добавить(СтрШаблон(НСтр("ru = 'Обработчик: %1.'"), ИмяОбработчика));
	
	Если ПараметрыОбработчика <> Неопределено Тогда
		Для Каждого ПараметрОбработчика Из ПараметрыОбработчика Цикл
			ПредставлениеОшибки.Добавить(СтрШаблон(НСтр("ru = '%1: %2.'"),
				Строка(ПараметрОбработчика.Ключ), Строка(ПараметрОбработчика.Значение)));
		КонецЦикла;
	КонецЕсли;
	
	ПредставлениеОшибки.Добавить(СтрШаблон(НСтр("ru = 'Текст ошибки: %1'"), ТекстИсключения));
	
	ТекстОшибки = СтрСоединить(ПредставлениеОшибки, Символы.ПС);
	
	ЗаписьЖурналаРегистрации(СтрШаблон(НСтр("ru = '%1: %2'"), СобытиеЖурналаРегистрацииСервисEDI(), ИмяОбработчика),
		УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);

	Возврат ТекстОшибки
		
КонецФункции

Функция ПредставлениеОбъектаДляЖурнала(Объект, МетаданныеДляПредставленияСтруктуры = Неопределено)
	
	ТипОбъекта           = ТипЗнч(Объект);
	МетаданныеОбъекта    = Метаданные.НайтиПоТипу(ТипОбъекта);
	ПредставлениеОбъекта = Строка(Объект);
	НавигационнаяСсылка  = "";
	
	Если МетаданныеОбъекта <> Неопределено
		И ОбщегоНазначения.ЭтоОбъектСсылочногоТипа(МетаданныеОбъекта)
		И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(Объект.Ссылка);
	Иначе
		
		Если ТипОбъекта = Тип("ОбъектXDTO") Тогда
			
			КоллекцияСвойств = Объект.Свойства();
			ПредставлениеОбъекта = "";
			ТипОбъекта = Объект.Тип().Имя;
			
			Если КоллекцияСвойств.Количество() > 0 И КоллекцияСвойств.Получить("КлючевыеСвойства") <> Неопределено Тогда
				КлючевыеСвойства = Объект.Получить("КлючевыеСвойства");
				
				Реквизиты = Новый Структура("Наименование, Код, КодВПрограмме, Номер, Дата");
				ЗаполнитьЗначенияСвойств(Реквизиты, КлючевыеСвойства);
				
				ПредставлениеОбъекта = ПредставлениеКоллекцииСвойствДляЖурнала(Реквизиты);
			Иначе
				Реквизиты = Новый Структура("Наименование, Код, КодВПрограмме, Номер, Дата");
				ЗаполнитьЗначенияСвойств(Реквизиты, Объект);
				
				ПредставлениеОбъекта = ПредставлениеКоллекцииСвойствДляЖурнала(Реквизиты);
			КонецЕсли;
			
		ИначеЕсли ТипОбъекта = Тип("Структура") Тогда
			
			СформироватьПредставлениеДляСтруктуры = Истина;
			Если Объект.Свойство("Ссылка")
				И ЗначениеЗаполнено(Объект.Ссылка) Тогда
				ТипОбъекта = ТипЗнч(Объект.Ссылка);
				Если ОбщегоНазначения.ЭтоСсылка(ТипОбъекта) Тогда
					ПредставлениеОбъекта = Строка(Объект.Ссылка);
					НавигационнаяСсылка  = ПолучитьНавигационнуюСсылку(Объект.Ссылка);
					
					СформироватьПредставлениеДляСтруктуры = Ложь;
				КонецЕсли;
			КонецЕсли;
			
			Если СформироватьПредставлениеДляСтруктуры Тогда
				ТипОбъекта = Строка(ТипЗнч(Объект));
				Если Не МетаданныеДляПредставленияСтруктуры = Неопределено Тогда
					ТипОбъекта = ТипОбъекта + "<" + МетаданныеДляПредставленияСтруктуры.Представление() + ">";
				КонецЕсли;
				
				ПредставлениеОбъекта = ПредставлениеКоллекцииСвойствДляЖурнала(Объект);
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	ПредставлениеОбъекта = СтрШаблон(НСтр("ru = '%1, %2 (%3)'"), ТипОбъекта, ПредставлениеОбъекта, НавигационнаяСсылка);
	
	Возврат ПредставлениеОбъекта;
	
КонецФункции

Функция ПредставлениеКоллекцииСвойствДляЖурнала(КоллекцияСвойств)
	
	Представление = Строка(КоллекцияСвойств);
	
	ЭлементыПредставления = Новый Массив;
				
	ЗначениеСвойства = Неопределено;
	
	Если КоллекцияСвойств.Свойство("Наименование", ЗначениеСвойства)
		И ЗначениеЗаполнено(ЗначениеСвойства) Тогда
		ЭлементыПредставления.Добавить(СокрЛП(ЗначениеСвойства));
	КонецЕсли;
	
	Если КоллекцияСвойств.Свойство("Код", ЗначениеСвойства)
		И ЗначениеЗаполнено(ЗначениеСвойства) Тогда
		ЭлементыПредставления.Добавить("(" + СокрЛП(ЗначениеСвойства) + ")");
	ИначеЕсли КоллекцияСвойств.Свойство("КодВПрограмме", ЗначениеСвойства)
		И ЗначениеЗаполнено(ЗначениеСвойства) Тогда
		ЭлементыПредставления.Добавить("(" + СокрЛП(ЗначениеСвойства) + ")");
	КонецЕсли;
	
	Если КоллекцияСвойств.Свойство("Номер", ЗначениеСвойства)
		И ЗначениеЗаполнено(ЗначениеСвойства) Тогда
		
		ЗначениеСвойстваДата = Неопределено;
		Если КоллекцияСвойств.Свойство("Дата", ЗначениеСвойстваДата)
			И ЗначениеЗаполнено(ЗначениеСвойстваДата) Тогда
			ЭлементыПредставления.Добавить(
				СтрШаблон(НСтр("ru = '№%1 от %2'"), ЗначениеСвойства, Формат(ЗначениеСвойстваДата, "ДЛФ=D")));
		Иначе
			ЭлементыПредставления.Добавить(
				СтрШаблон(НСтр("ru = '№%1'"), ЗначениеСвойства));
		КонецЕсли;
		
	ИначеЕсли КоллекцияСвойств.Свойство("Дата", ЗначениеСвойства)
		И ЗначениеЗаполнено(ЗначениеСвойства) Тогда
		
		ЭлементыПредставления.Добавить(
			СтрШаблон(НСтр("ru = 'от %1'"), ЗначениеСвойства));
	КонецЕсли;
	
	Если ЭлементыПредставления.Количество() > 0 Тогда
		Представление = СтрСоединить(ЭлементыПредставления, " ");
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти

#Область ПоискПравилКонвертации

#Область ПравилаОбработкиДанных

Функция ПравилоОбработкиОбъектаМетаданных(Знач КомпонентыОбмена, Знач ОбъектКонфигурации)
	
	Возврат КомпонентыОбмена.ПравилаОбработкиДанных.Найти(ОбъектКонфигурации, "ОбъектВыборкиМетаданные");

КонецФункции

#КонецОбласти

#Область ПравилаКонвертацииОбъектов

Функция ПравилоКонвертации(Знач КомпонентыОбмена, Знач ОбъектФормата, Знач ОбъектКонфигурации)
	
	Результат = КомпонентыОбмена.ПравилаКонвертацииОбъектов.НайтиСтроки(
		Новый Структура("ОбъектФормата, ОбъектДанных", ОбъектФормата, ОбъектКонфигурации));
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Результат[0];
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ФормализацияЗначений

Функция АктуальныйФорматУниверсальногоОбменаДанными()
	
	Возврат "1.8";
	
КонецФункции

Функция СобытиеЖурналаРегистрацииСервисEDI()
	
	Возврат НСтр("ru = 'Сервис 1С:EDI - конвертация данных.'", ОбщегоНазначения.КодОсновногоЯзыка())
	
КонецФункции

Функция НаправлениеОбменаОтправка()
	
	Возврат "Отправка"
	
КонецФункции

Функция НаправлениеОбменаПолучение()
	
	Возврат "Получение"
	
КонецФункции

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

Функция ПространствоИменФормата(Знач ВерсияФормата)
	
	Возврат СтрШаблон("http://v8.1c.ru/edi/edi_stnd/EnterpriseData/%1", ВерсияФормата);
	
КонецФункции

Функция КомпонентыОбмена(Знач НаправлениеОбмена, Знач ПространствоИмен, Знач ВерсияФорматаОбмена)
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена(НаправлениеОбмена);
	КомпонентыОбмена.ЭтоОбменЧерезПланОбмена = Ложь;
	КомпонентыОбмена.КлючСообщенияЖурналаРегистрации = НСтр("ru = 'Преобразование данных сервиса 1С:EDI'");
	КомпонентыОбмена.ВерсияФорматаОбмена = ВерсияФорматаОбмена;
	КомпонентыОбмена.XMLСхема = ПространствоИмен;
	
	КомпонентыОбмена.Вставить("ЭтоОбменEDI", Истина);
	
	ВерсииФорматаОбмена = Новый Соответствие;
	ОбменДаннымиПереопределяемый.ПриПолученииДоступныхВерсийФормата(ВерсииФорматаОбмена);
	КомпонентыОбмена.МенеджерОбмена = ОбменДаннымиXDTOСервер.МенеджерОбменаВерсииФормата(ВерсияФорматаОбмена);
	
	Если КомпонентыОбмена.МенеджерОбмена = Неопределено Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Не поддерживается версия формата обмена: <%1>.'"), ВерсияФорматаОбмена);
	КонецЕсли;
	
	ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена);
	
	Возврат КомпонентыОбмена;
	
КонецФункции

#КонецОбласти

#КонецОбласти


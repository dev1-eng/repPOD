#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.СчетФактураВыданныйАванс.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	УчетНДСУП.СформироватьДвиженияВРегистры(ДополнительныеСвойства, Движения, Отказ);
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.ИмяТЧ = "Авансы";
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ,ПараметрыПроверки);
	
	Если ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ВводОстатков") 
		И ТипЗнч(ДокументОснование) <> Тип("ДокументСсылка.ВзаимозачетЗадолженности") Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(НомерПлатежноРасчетногоДокумента)
		И НЕ ЗначениеЗаполнено(ДатаПлатежноРасчетногоДокумента) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("НомерПлатежноРасчетногоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаПлатежноРасчетногоДокумента");
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.Ссылка) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерИсправления");
	КонецЕсли;
	
	Если НЕ Исправление Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетФактураОснование");
		МассивНепроверяемыхРеквизитов.Добавить("НомерИсправления");
	КонецЕсли;
	
	Если НЕ Корректировочный Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Авансы.ИсходныйСчетФактура");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ПроверитьДублиСчетФактуры(Отказ);
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Сумма    = Авансы.Итог("Сумма");
	СуммаНДС = Авансы.Итог("СуммаНДС");
	
	Если НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДСУПокупателя Тогда
		СтавкаПоУмолчанию = УчетНДСУП.СтавкаНДСПоУмолчанию(Дата, Истина);
		Для Каждого СтрокаАванса Из Авансы Цикл
			СтрокаАванса.СтавкаНДС = СтавкаПоУмолчанию;
		КонецЦикла;
	КонецЕсли;
	
	СформироватьСтрокуРасчетноПлатежныхДокументов();
	ЗаполнитьДатуПолученияАванса();
	
	// заполнение признака СводныйКорректировочный
	ИсходныеСФ = Авансы.Выгрузить(,"ИсходныйСчетФактура");
	ИсходныеСФ.Свернуть("ИсходныйСчетФактура");
	Если Корректировочный Тогда
		Если ИсходныеСФ.Количество() = 1 Тогда
			СводныйКорректировочный = Ложь;
		Иначе
			СводныйКорректировочный = Истина;
		КонецЕсли;
	Иначе
		СводныйКорректировочный = Ложь;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		РучнаяКорректировкаЖурналаСФ = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Исправление Тогда
		
		// Установка номера по исходному документу.
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА СчетФактураВыданныйАванс.Исправление
		|			ТОГДА СчетФактураВыданныйАванс.СчетФактураОснование
		|		ИНАЧЕ СчетФактураВыданныйАванс.Ссылка
		|	КОНЕЦ                          КАК Ссылка,
		|	СчетФактураВыданныйАванс.Номер КАК Номер
		|ПОМЕСТИТЬ ИсходныеДокументы
		|ИЗ Документ.СчетФактураВыданныйАванс КАК СчетФактураВыданныйАванс
		|ГДЕ
		|	СчетФактураВыданныйАванс.Ссылка = &СчетФактураОснование
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИсходныеДокументы.Номер КАК Номер,
		|	ЕСТЬNULL(Исправления.НомерИсправления, 0) КАК НомерИсправления
		|ИЗ
		|	ИсходныеДокументы КАК ИсходныеДокументы
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданныйАванс КАК Исправления
		|		ПО ИсходныеДокументы.Ссылка = Исправления.СчетФактураОснование
		|			И ИсходныеДокументы.Ссылка <> Исправления.Ссылка
		|			И Исправления.Исправление
		|			И НЕ Исправления.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерИсправления УБЫВ");
		
		Запрос.УстановитьПараметр("СчетФактураОснование", СчетФактураОснование);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			СтандартнаяОбработка = Ложь;
			// Установка номера и переопределение префикса информационной базы.
			ИспользоватьПрефикс = Константы.ВестиОтдельнуюНумерациюСчетовФактурНаАвансы.Получить();
			Если ИспользоватьПрефикс Тогда
				Префикс = "ИА";
				ДлинаПрефикса = 2;
			Иначе
				Префикс = "И";
				ДлинаПрефикса = 1;
			КонецЕсли;
			ПрефиксацияОбъектовСобытия.УстановитьПрефиксИнформационнойБазыИОрганизации(ЭтотОбъект, СтандартнаяОбработка, Префикс);
			
			НомерБезПрефикса = ПрефиксацияОбъектовКлиентСервер.УдалитьПрефиксыИзНомераОбъекта(Выборка.Номер, Истина, Истина);
			Если СтрДлина(СокрП(НомерБезПрефикса)) = 7 Тогда
				НомерБезПрефикса = Прав(НомерБезПрефикса, СтрДлина(НомерБезПрефикса)-ДлинаПрефикса);
			КонецЕсли;
			Номер = Префикс + НомерБезПрефикса;
			НомерИсправления = Формат(Число(Выборка.НомерИсправления) + 1, "ЧЦ=10; ЧДЦ=0; ЧГ=0");
		КонецЕсли;
	Иначе
		ИспользоватьПрефикс = Константы.ВестиОтдельнуюНумерациюСчетовФактурНаАвансы.Получить();
		Если ИспользоватьПрефикс Тогда
			Префикс = "А";
		Иначе
			Префикс = "0";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Исправление") 
			 И ДанныеЗаполнения.Исправление
			 И ДанныеЗаполнения.Свойство("СчетФактураОснование") Тогда
			ЗаполнитьИсправлениеПоСчетуФактуре(ДанныеЗаполнения);
		КонецЕсли;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") Тогда
		РеквизитыЗаполнения = РеквизитыПриходныйКассовыйОрдер(ДанныеЗаполнения);
		ЗаполнитьПоПлатежномуДокументу(РеквизитыЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеБезналичныхДенежныхСредств") Тогда
		РеквизитыЗаполнения = РеквизитыПоступлениеБезналичныхДенежныхСредств(ДанныеЗаполнения);
		ЗаполнитьПоПлатежномуДокументу(РеквизитыЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		МассивДокументов= Новый Массив;
		МассивДокументов.Добавить(Ссылка);
		УчетНДСУП.СформироватьЗаданияПоДокументам(МассивДокументов);
	КонецЕсли;
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Организация") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Ответственный") Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Подразделение") Тогда
		Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	КонецЕсли;
	
КонецПроцедуры

Функция РеквизитыПриходныйКассовыйОрдер(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата					КАК Дата,
	|	ДанныеДокумента.Ссылка					КАК Ссылка,
	|	ДанныеДокумента.Проведен				КАК Проведен,
	|	ДанныеДокумента.ХозяйственнаяОперация	КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация				КАК Организация,
	|	ДанныеДокумента.Подразделение			КАК Подразделение,
	|	НЕОПРЕДЕЛЕНО							КАК ИдентификаторГосКонтракта,
	|	ВЫБОР КОГДА
	|		ДанныеДокумента.ХозяйственнаяОперация В (
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации),
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтДругойОрганизации)
	|		)
	|	ТОГДА
	|		ДанныеДокумента.КассаОтправитель.Владелец
	|	ИНАЧЕ
	|		ДанныеДокумента.Контрагент
	|	КОНЕЦ 									КАК Контрагент
	|ИЗ
	|	Документ.ПриходныйКассовыйОрдер КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка;
	
КонецФункции

Функция РеквизитыПоступлениеБезналичныхДенежныхСредств(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата					КАК Дата,
	|	ДанныеДокумента.Ссылка					КАК Ссылка,
	|	ДанныеДокумента.Проведен				КАК Проведен,
	|	ДанныеДокумента.ХозяйственнаяОперация	КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация				КАК Организация,
	|	ДанныеДокумента.Подразделение			КАК Подразделение,
	|	ДанныеДокумента.ПроведеноБанком			КАК ПроведеноБанком,
	|	&ИдентификаторГосКонтракта				КАК ИдентификаторГосКонтракта,
	|	ВЫБОР КОГДА
	|		ДанныеДокумента.ХозяйственнаяОперация В (
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации),
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтДругойОрганизации)
	|		)
	|	ТОГДА
	|		ДанныеДокумента.БанковскийСчетОтправитель.Владелец
	|	ИНАЧЕ
	|		ДанныеДокумента.Контрагент
	|	КОНЕЦ 									КАК Контрагент
	|ИЗ
	|	Документ.ПоступлениеБезналичныхДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, 
		"&ИдентификаторГосКонтракта",
		"НЕОПРЕДЕЛЕНО");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка;
	
КонецФункции

Процедура ЗаполнитьПоПлатежномуДокументу(РеквизитыЗаполнения)
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(РеквизитыЗаполнения.Ссылка, , НЕ РеквизитыЗаполнения.Проведен);
	
	ОперацииНДС = ХозяйственныеОперацииНДСАванс();
	Если ОперацииНДС.Найти(РеквизитыЗаполнения.ХозяйственнаяОперация) = Неопределено Тогда
		ТекстОшибки = НСтр("ru='Не требуется вводить счет-фактуру на аванс на основании документа %Документ%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", РеквизитыЗаполнения.Ссылка);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(РеквизитыЗаполнения, "ПроведеноБанком")
		И РеквизитыЗаполнения.ПроведеноБанком <> Истина Тогда
		ТекстОшибки = НСтр("ru='Перед вводом счета-фактуры на аванс по документу %Документ% необходимо установить признак ""Проведено банком""'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", РеквизитыЗаполнения.Ссылка);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыЗаполнения, "Организация, Контрагент, ИдентификаторГосКонтракта");
	РеквизитыКонтрагента = Справочники.Контрагенты.РеквизитыКонтрагента(Контрагент, ТекущаяДатаСеанса());
	ИННКонтрагента = РеквизитыКонтрагента.ИНН;
	КППКонтрагента = РеквизитыКонтрагента.КПП;
	
	ДокументОснование	= РеквизитыЗаполнения.Ссылка;
	ДатаВыставления		= ТекущаяДатаСеанса();
	
	ВходящийНомерИДата = Документы.СчетФактураВыданныйАванс.ВходящийНомерИДатаДокумента(ДокументОснование, Контрагент);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВходящийНомерИДата);
	
	Если Не ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
		Запрос = Новый Запрос();
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	РасчетыСКлиентами.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентами КАК РасчетыСКлиентами
		|ГДЕ
		|	РасчетыСКлиентами.Регистратор = &Ссылка
		|	И РасчетыСКлиентами.Активность
		|";
		Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
		
		ТаблицаАналитик = Запрос.Выполнить().Выгрузить();
		МассивАналитикУчетаПоПартнерам = ТаблицаАналитик.ВыгрузитьКолонку("АналитикаУчетаПоПартнерам");
		
		Если МассивАналитикУчетаПоПартнерам.Количество() > 0 Тогда
			АналитикиРасчета = РаспределениеВзаиморасчетовВызовСервера.АналитикиРасчета();
			АналитикиРасчета.АналитикиУчетаПоПартнерам = МассивАналитикУчетаПоПартнерам;
			Попытка
				РаспределениеВзаиморасчетовВызовСервера.РаспределитьВсеРасчетыСКлиентами(КонецМесяца(РеквизитыЗаполнения.Дата),АналитикиРасчета);
			Исключение
				ТекстСообщения = НСтр("ru ='Печатная форма сформирована по неактуальным данным.
				|Необходимо актуализировать взаиморасчеты вручную и переформировать печатную форму.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
	ОтборАвансов = Документы.СчетФактураВыданныйАванс.ОтборПолученныхАвансов();
	ОтборАвансов.Вставить("НачалоПериода",		 НачалоДня(РеквизитыЗаполнения.Дата));
	ОтборАвансов.Вставить("КонецПериода",		 КонецКвартала(РеквизитыЗаполнения.Дата));
	ОтборАвансов.Вставить("Организация",		 Организация);
	ОтборАвансов.Вставить("РасчетныйДокумент",	 ДокументОснование);
	ОтборАвансов.Вставить("ПравилоОтбораАванса", Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.ВсеОплаты);
	
	ПолученныеАвансы = Новый ТаблицаЗначений;
	ПолученныеАвансы.Колонки.Добавить("СФсформирован");
	ПолученныеАвансы.Колонки.Добавить("СчетФактура");
	ПолученныеАвансы.Колонки.Добавить("СуммаСчетаФактуры");
	ПолученныеАвансы.Колонки.Добавить("Контрагент");
	ПолученныеАвансы.Колонки.Добавить("Сумма");
	ПолученныеАвансы.Колонки.Добавить("НаправлениеДеятельности");
	ПолученныеАвансы.Колонки.Добавить("СтавкаНДС");
	ПолученныеАвансы.Колонки.Добавить("СуммаНДС");
	ПолученныеАвансы.Колонки.Добавить("ДатаВыписки");
	
	Документы.СчетФактураВыданныйАванс.ЗаполнитьПолученныеАвансыДляСФ(ОтборАвансов, ПолученныеАвансы);
	
	ПравилоОтбораАванса = ОтборАвансов.ПравилоОтбораАванса;
	
	ПолученныеАвансы.Свернуть("СтавкаНДС,НаправлениеДеятельности", "Сумма, СуммаНДС");
	Для Каждого СтрокаАванса Из ПолученныеАвансы Цикл
		СтрокаДокумента = Авансы.Добавить();
		СтрокаДокумента.ТипЗапасов = Перечисления.ТипыЗапасов.Товар;
		ЗаполнитьЗначенияСвойств(СтрокаДокумента, СтрокаАванса);
	КонецЦикла;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов") Тогда
		// Заполним товары счета-фактуры по заказам
		Товары = Документы.СчетФактураВыданныйАванс.ТоварыЗаказовКлиентов(ДокументОснование);
		Если Товары.Количество() <> 0 Тогда
			ТаблицаАвансы = Авансы.Выгрузить();
			Документы.СчетФактураВыданныйАванс.РаспределитьАвансыПоТоварам(ТаблицаАвансы, Товары, ДокументОснование);
			Авансы.Загрузить(ТаблицаАвансы);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьИсправлениеПоСчетуФактуре(ДанныеЗаполнения = Неопределено) Экспорт
	
	Если ДанныеЗаполнения <> Неопределено Тогда
		Основание = ДанныеЗаполнения.СчетФактураОснование;
	Иначе
		Основание = СчетФактураОснование;
		Исправление = Истина;
	КонецЕсли;
	
	РеквизитыСчетаФактуры = Документы.СчетФактураВыданныйАванс.ДанныеСчетаФактуры(Основание);
	Для Каждого РеквизитСФ Из РеквизитыСчетаФактуры Цикл
		
		ИмяРеквизита      = РеквизитСФ.Ключ;
		ЗначениеРеквизита = РеквизитСФ.Значение;
		
		Если ИмяРеквизита = "Авансы" Тогда
			Авансы.Загрузить(ЗначениеРеквизита);
		ИначеЕсли ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
			Если ДанныеЗаполнения <> Неопределено Тогда
				ДанныеЗаполнения.Вставить(ИмяРеквизита, ЗначениеРеквизита);
			Иначе
				ЭтотОбъект[ИмяРеквизита] = ЗначениеРеквизита;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ПроверитьДублиСчетФактуры(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.ДокументОснование КАК ДокументОснование
	|ИЗ
	|	Документ.СчетФактураВыданныйАванс КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка <> &Ссылка
	|	И ДанныеДокумента.ДокументОснование = &ДокументОснование
	|	И ДанныеДокумента.НалогообложениеНДС = &НалогообложениеНДС
	|	И ДанныеДокумента.Проведен
	|	И НЕ ДанныеДокумента.Исправление
	|	И ДанныеДокумента.Контрагент = &Контрагент";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		
		Если НЕ Исправление Тогда
		
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для документа %1 уже введен счет-фактура %2'"),
				ДокументОснование,
				Выборка.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"ДокументОснование",
				,
				Отказ);
			
		ИначеЕсли Исправление И СчетФактураОснование <> Выборка.Ссылка Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'На основании документа %1 введен счет-фактура %2. Недопустимо исправление счета-фактуры %3.'"),
				Выборка.ДокументОснование,
				Выборка.Ссылка,
				СчетФактураОснование);
				
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				,
				,
				Отказ);
				
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьСтрокуРасчетноПлатежныхДокументов()
	
	Если НЕ ЗначениеЗаполнено(ДокументОснование) Тогда
		СтрокаПлатежноРасчетныеДокументы = "";
		Возврат;
	КонецЕсли;
	
	СтрокаПлатежноРасчетныеДокументы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 от %2'"),
		НомерПлатежноРасчетногоДокумента,
		Формат(ДатаПлатежноРасчетногоДокумента, "ДЛФ=D"));
		
КонецПроцедуры

Процедура ЗаполнитьДатуПолученияАванса()
	
	Если Исправление Тогда
		ДатаПолученияАванса = Дата;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("Организация",       Организация);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(РеестрДокументов.ДатаОтраженияВУчете, ДанныеПервичныхДокументов.ДатаРегистратора) КАК ДатаПолученияАванса
	|ИЗ
	|	РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РеестрДокументов КАК РеестрДокументов
	|		ПО РеестрДокументов.Ссылка = &ДокументОснование
	|			И РеестрДокументов.Организация = &Организация
	|			И НЕ РеестрДокументов.ДополнительнаяЗапись
	|ГДЕ
	|	ДанныеПервичныхДокументов.Организация = &Организация
	|	И ДанныеПервичныхДокументов.Документ = &ДокументОснование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДатаПолученияАванса = Выборка.ДатаПолученияАванса;
	Иначе
		ДатаПолученияАванса = Дата;
	КонецЕсли;
	
КонецПроцедуры

Функция ХозяйственныеОперацииНДСАванс()
	
	Операции = Новый Массив;
	Операции.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента);
	Операции.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиентаПоПлатежнойКарте);
	Операции.Добавить(Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации);
	
	Возврат Операции;
	
КонецФункции	

#КонецОбласти

#КонецОбласти

#КонецЕсли

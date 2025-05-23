#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ПередЗаписью(Отказ)
	
	// Вызывается непосредственно до записи объекта в базу данных
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	РеквизитыСсылки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ПометкаУдаления, СтатусЭД");
	
	Если НЕ Отказ И СтатусЭД <> РеквизитыСсылки.СтатусЭД Тогда

		Если ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовВерсииЭД.ПОА И СтатусЭД <> РеквизитыСсылки.СтатусЭД Тогда
			ПараметрыВладельцаЭД = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭлектронныйДокументВладелец,
				"ВладелецФайла, СтатусЭД, НаправлениеЭД");
			Если ПараметрыВладельцаЭД.СтатусЭД = Перечисления.СтатусыЭД.ПолученоПредложениеОбАннулировании
				ИЛИ ПараметрыВладельцаЭД.СтатусЭД = Перечисления.СтатусыЭД.СформированоПредложениеОбАннулировании Тогда
				Если (СтатусЭД = Перечисления.СтатусыЭД.ОтправленоПодтверждение
						ИЛИ СтатусЭД = Перечисления.СтатусыЭД.ПодготовленоПодтверждение
						ИЛИ СтатусЭД = Перечисления.СтатусыЭД.ПолученоПодтверждение) Тогда
					ОбменСКонтрагентамиСлужебный.УстановитьСтатусЭД(ЭлектронныйДокументВладелец,
						Перечисления.СтатусыЭД.Аннулирован);
				ИначеЕсли (СтатусЭД = Перечисления.СтатусыЭД.ОтклоненПолучателем
						ИЛИ СтатусЭД = Перечисления.СтатусыЭД.Отклонен) Тогда
						
					НовыйСтатусЭД = СтатусДоАннулирования(ПараметрыВладельцаЭД.ВладелецФайла,
						ЭлектронныйДокументВладелец, ПараметрыВладельцаЭД.НаправлениеЭД);
					СтруктураПараметров = Новый Структура;
					СтруктураПараметров.Вставить("СтатусЭД", НовыйСтатусЭД);
					СтруктураПараметров.Вставить("ОтклонениеАннулирования", Истина);

					ОбменСКонтрагентамиСлужебный.ИзменитьПоСсылкеПрисоединенныйФайл(ЭлектронныйДокументВладелец,
						СтруктураПараметров, Ложь);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Установка пометки удаления производится только с дополнительным свойством объекта "ПомечатьНаУдалениеПодписанныеОбъекты".
	Если НЕ Отказ И НЕ ДополнительныеСвойства.Свойство("ПомечатьНаУдалениеПодписанныеОбъекты") Тогда
		Если ПометкаУдаления = Истина И РеквизитыСсылки.ПометкаУдаления = Ложь Тогда
			Если ЗначениеЗаполнено(ЭлектронныйДокументВладелец) Тогда
				ПодписанЭПЭлектронныйДокументВладелец = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлектронныйДокументВладелец, "ПодписанЭП");
			Иначе
				ПодписанЭПЭлектронныйДокументВладелец = Неопределено;
			КонецЕсли;
			Если ПодписанЭП ИЛИ (ЗначениеЗаполнено(ПодписанЭПЭлектронныйДокументВладелец) И ПодписанЭПЭлектронныйДокументВладелец) Тогда
				ПометкаУдаления = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Синхронизация наименования.
	ДлинаНаименования = СтрДлина(Наименование);
	Если Лев(НаименованиеФайла, ДлинаНаименования) <> Наименование Тогда
		НаименованиеФайла = Наименование;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтатусДоАннулирования(ЭлектронныйДокумент, ФайлЭлектронногоДокумента, НаправлениеЭД)
	
	Если НаправлениеЭД = Перечисления.НаправленияЭД.Входящий Тогда
		НовыйСтатусЭД = СтатусВходящегоТитулаДоАннулирования(ФайлЭлектронногоДокумента);
		Возврат НовыйСтатусЭД;
	КонецЕсли;
	
	СвойстваЭлектронногоДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
		ЭлектронныйДокумент, "ВидЭД, ТребуетсяИзвещение");
	
	Если ОбменСКонтрагентамиСлужебный.ЭтоФНС(СвойстваЭлектронногоДокумента.ВидЭД) Тогда
		НовыйСтатусЭД = СтатусИсходящегоТитулаФНСДоАннулирования(ФайлЭлектронногоДокумента);
	Иначе
		НовыйСтатусЭД = СтатусИсходящегоПервичногоДокументаДоАннулирования(ФайлЭлектронногоДокумента);
	КонецЕсли;
	
	Если НовыйСтатусЭД = Перечисления.СтатусыЭД.Доставлен
		И Не СвойстваЭлектронногоДокумента.ТребуетсяИзвещение Тогда
		НовыйСтатусЭД = Перечисления.СтатусыЭД.Отправлен;
	КонецЕсли;
	
	Возврат НовыйСтатусЭД;
	
КонецФункции

Функция СтатусВходящегоТитулаДоАннулирования(ФайлЭлектронногоДокумента)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Журнал.СтатусЭД КАК СтатусЭД
		|ИЗ
		|	РегистрСведений.ЖурналСобытийЭД КАК Журнал
		|ГДЕ
		|	Журнал.ПрисоединенныйФайл = &ЭлектронныйДокументВладелец
		|	И НЕ Журнал.СтатусЭД В (&ПредложенияОбАннулировании)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Журнал.НомерЗаписи УБЫВ");
	
	Запрос.УстановитьПараметр("ЭлектронныйДокументВладелец", ФайлЭлектронногоДокумента);
	
	ПредложенияОбАннулировании = Новый Массив;
	ПредложенияОбАннулировании.Добавить(Перечисления.СтатусыЭД.ПолученоПредложениеОбАннулировании);
	ПредложенияОбАннулировании.Добавить(Перечисления.СтатусыЭД.СформированоПредложениеОбАннулировании);
	Запрос.УстановитьПараметр("ПредложенияОбАннулировании", ПредложенияОбАннулировании);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		НовыйСтатусЭД = Выборка.СтатусЭД;
	Иначе
		НовыйСтатусЭД = Перечисления.СтатусыЭД.Получен;
	КонецЕсли;
	
	Возврат НовыйСтатусЭД;
	
КонецФункции

Функция СтатусИсходящегоТитулаФНСДоАннулирования(ФайлЭлектронногоДокумента)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВЫБОР
		|		КОГДА ЭДПрисоединенныеФайлы.ТипЭлементаВерсииЭД В (&ТипыИзвещенийОПолучении)
		|			ТОГДА 0
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК ИндексСтатусаЭД
		|ИЗ
		|	Справочник.ЭДПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
		|ГДЕ
		|	ЭДПрисоединенныеФайлы.ЭлектронныйДокументВладелец = &ЭлектронныйДокументВладелец
		|	И ЭДПрисоединенныеФайлы.ТипЭлементаВерсииЭД В(&ТипыЭлементовВерсииЭД)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ИндексСтатусаЭД УБЫВ");
	
	Запрос.УстановитьПараметр("ЭлектронныйДокументВладелец", ФайлЭлектронногоДокумента);
	
	ТипыИзвещенийОПолучении = Новый Массив;
	ТипыИзвещенийОПолучении.Добавить(Перечисления.ТипыЭлементовВерсииЭД.ИОП);
	ТипыИзвещенийОПолучении.Добавить(Перечисления.ТипыЭлементовВерсииЭД.ИПЭСФ);
	Запрос.УстановитьПараметр("ТипыИзвещенийОПолучении", ТипыИзвещенийОПолучении);
	
	ТипыЭлементовВерсииЭД = ОбменСКонтрагентамиСлужебный.ТипыОтветныхТитулов();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ТипыЭлементовВерсииЭД, ТипыИзвещенийОПолучении);
	Запрос.УстановитьПараметр("ТипыЭлементовВерсииЭД", ТипыЭлементовВерсииЭД);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		НовыйСтатусЭД = Перечисления.СтатусыЭД.Отправлен;
	ИначеЕсли Выборка.ИндексСтатусаЭД = 0 Тогда
		НовыйСтатусЭД = Перечисления.СтатусыЭД.Доставлен;
	ИначеЕсли Выборка.ИндексСтатусаЭД = 1 Тогда
		НовыйСтатусЭД = Перечисления.СтатусыЭД.ПолученоПодтверждение;
	КонецЕсли;
	
	Возврат НовыйСтатусЭД;
	
КонецФункции

Функция СтатусИсходящегоПервичногоДокументаДоАннулирования(ФайлЭлектронногоДокумента)
	
	НовыйСтатусЭД = Неопределено;
	
	МассивПодписей = ЭлектроннаяПодпись.УстановленныеПодписи(ФайлЭлектронногоДокумента);
	Если ЗначениеЗаполнено(МассивПодписей) Тогда
		Запрос = Новый Запрос(
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	Журнал.Дата КАК Дата
			|ИЗ
			|	РегистрСведений.ЖурналСобытийЭД КАК Журнал
			|ГДЕ
			|	Журнал.ПрисоединенныйФайл = &ЭлектронныйДокументВладелец
			|	И Журнал.СтатусЭД = ЗНАЧЕНИЕ(Перечисление.СтатусыЭД.ПодготовленКОтправке)");
		Запрос.УстановитьПараметр("ЭлектронныйДокументВладелец", ФайлЭлектронногоДокумента);
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		Для Каждого Подпись Из МассивПодписей Цикл
			Если Подпись.ДатаПодписи > Выборка.Дата Тогда
				НовыйСтатусЭД = Перечисления.СтатусыЭД.ПолученоПодтверждение;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если НовыйСтатусЭД <> Неопределено Тогда
		Возврат НовыйСтатусЭД;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЭДПрисоединенныеФайлы.ТипЭлементаВерсииЭД КАК ТипЭлементаВерсииЭД
		|ИЗ
		|	Справочник.ЭДПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
		|ГДЕ
		|	ЭДПрисоединенныеФайлы.ЭлектронныйДокументВладелец = &ЭлектронныйДокументВладелец
		|	И ЭДПрисоединенныеФайлы.ТипЭлементаВерсииЭД = ЗНАЧЕНИЕ(Перечисление.ТипыЭлементовВерсииЭД.ИОП)");
	Запрос.УстановитьПараметр("ЭлектронныйДокументВладелец", ФайлЭлектронногоДокумента);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		НовыйСтатусЭД = Перечисления.СтатусыЭД.Отправлен;
	Иначе
		НовыйСтатусЭД = Перечисления.СтатусыЭД.Доставлен;
	КонецЕсли;
	
	Возврат НовыйСтатусЭД;
	
КонецФункции

#КонецОбласти

#Иначе
	
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
	
#КонецЕсли
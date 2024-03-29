//
//  RaceDisplayDataService.swift
//  EntainNextToGo
//
//  Created by Sean Smith on 2/3/2024.
//

import Foundation
import Combine

/// A function that returns a data object for the purposes of comparing race summary start times with the specified current date time. 
public typealias RaceCurrentDateTime = (() -> Date)

/// Service that returns the data based on filters and maximum expiry time option.
@Observable final public class RaceDisplayDataService {

    /// Original race summary models
    private var raceSummaries: [RaceSummary] = []
    /// The display should observe and react to changes to this data based on filters.
    private(set) var displayRaceSummaries: [RaceSummary] = []
    /// Maximum expiry time in seconds. Default should be negative 60 seconds eg. Race started 60 seconds ago.
    private var raceExpirySeconds: Double
    /// The date time refence that uses the compare to determine validity of a race.
    private var currentDateTime: RaceCurrentDateTime
    /// Active race data filters
    ///
    /// When this value is updated, the display data is updated.
    public var raceSummaryFilters: [RaceCategory] = [.horse, .harness, .greyhound] {
        didSet {
            updateDisplayRaceSummaryData()
        }
    }

    // MARK: - Lifecyle

    init(
        raceSummaries: [RaceSummary] = [],
        raceSummaryFilters: [RaceCategory] = [.horse, .harness, .greyhound],
        raceExpirySeconds: Double = 60,
        currentDateTime: @escaping RaceCurrentDateTime
    ) {
        self.raceSummaries = raceSummaries
        self.raceExpirySeconds = raceExpirySeconds
        self.raceSummaryFilters = raceSummaryFilters
        self.currentDateTime = currentDateTime
        updateDisplayRaceSummaryData()
    }

}

// MARK: - Private Methods

private extension RaceDisplayDataService {

    /// Sets the display data to be based on filtered data.
    func updateDisplayRaceSummaryData() {
        let races = getValidStartTimeRaceData()
        displayRaceSummaries = getStartTimeSortedRaceData(for: races)
    }

    /// Sort the race data in order of start date.
    ///
    /// We want the date sorted based on lowest value to highest value where lowest value is first and highest value is last.
    func getStartTimeSortedRaceData(for races: [RaceSummary]) -> [RaceSummary] {
        races.sorted {
            let a = $0.advertisedStart.seconds.rounded(.toNearestOrAwayFromZero)
            let b = $1.advertisedStart.seconds.rounded(.toNearestOrAwayFromZero)
            if a == b {
                // If the seconds are equal, sort alphabetically by raceName
                return $0.raceName < $1.raceName
            } else {
                // Otherwise, sort by the seconds
                return a < b
            }
        }
    }

    /// Using the race summary filters, return the race summaries.
    ///
    /// In the case that all 3 filters are active, we want to return all race summaries.
    func getFilteredRaceTypeData() -> [RaceSummary] {
        // If all categories are selected, return all race summaries
        if raceSummaryFilters.count == 3 {
            return raceSummaries
        }
        // Filter race summaries to only include those with matching categories
        return raceSummaries.filter {
            raceSummaryFilters.contains($0.categoryId.raceCategory)
        }
    }

    /// Returns all valid race start time data and excludes and races that have started before the date minus race expiry seconds.
    func getValidStartTimeRaceData() -> [RaceSummary] {
        // Calculate the race expiry date
        let raceExpiryDate = currentDateTime().timeIntervalSince1970 - raceExpirySeconds
        return getFilteredRaceTypeData().filter {
            $0.advertisedStart.seconds > raceExpiryDate
        }
    }

}

// MARK: - Public Methods

public extension RaceDisplayDataService {

    /// Handle new data for use.
    ///
    /// When recieving fresh race summary data, we need to update:
    /// - Set the race summaries data that contains all results.
    /// - Update the display data in accordance with the active parameters.
    func updateRaceSummaries(with summaries: [RaceSummary]) {
        raceSummaries = summaries
        updateDisplayRaceSummaryData()
    }

    /// Will return true if the first race summary start time is older than the date minue expiry
    func shouldUpdateDisplay() -> Bool {
        guard let summary = displayRaceSummaries.first else {
            return false
        }
        let raceExpiryDate = (currentDateTime().timeIntervalSince1970 - raceExpirySeconds).rounded(.toNearestOrAwayFromZero)
        let firstSummaryStartDate = summary.advertisedStart.seconds.rounded(.toNearestOrAwayFromZero)
        if firstSummaryStartDate <= raceExpiryDate {
            updateDisplayRaceSummaryData()
        }
        return firstSummaryStartDate <= raceExpiryDate
    }

}

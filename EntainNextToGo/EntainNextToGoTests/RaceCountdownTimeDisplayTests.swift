//
//  RaceCountdownTimeDisplayTests.swift
//  EntainNextToGoTests
//
//  Created by Sean Smith on 27/2/2024.
//

import XCTest
@testable import EntainNextToGo

/// Tests the conversion of date time into display time
///
/// These tests aim to reflect the experience provided on neds.com.au in the Next to Go feature.
final class RaceCountdownTimeDisplayTests: XCTestCase {

    // MARK: - Variables
    private let raceCountDownStringHelper = RaceCountDownStringHelper()

    // The time and date for creating the file was 27th February 19:55:09
    // Maintain this time for reference.
    private let mockDate = Date(fromString: "27 02 2024 19:56:09")

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Test Seconds

    /// Should return "XXs" for no minutes and double digit seconds
    func testShouldReturnTwoDigitSecondsForZeroMinutesDoubleDigitSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709035002
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "33s")
    }

    /// Should return "Xs" for no minutes and single digit seconds
    func testShouldReturnSingleDigitSecondsForZeroMinutesSingleDigitSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709034974
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "5s")
    }

    /// Should return "-XXs" for negative no minutes and  double digit seconds
    func testShouldReturnNegativeTwoDigitSecondsForNegativeZeroMinutesDoubleDigitSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709034934
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "-35s")
    }

    /// Should return "Xs" for negative no minutes and single digit seconds
    func testShouldReturnNegativeSingleDigitSecondsForNegativeZeroMinutesSingleDigitSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709034964
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "-5s")
    }

    // MARK: - Test Minutes

    /// Should return "Xm Xs" for single digit minutes and single digit seconds under 4 minutes 59 seconds
    func testShouldReturnSingleDigitMinutesSingleDigitSecondsForSingleDigitMinutesSingleDigitSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709035215
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "4m 6s")
    }

    /// Should return "-Xm Xs" for negative single digit minutes and single digit seconds under 4 minutes 59 seconds
    func testShouldReturnNegativeSingleDigitMinutesSingleDigitSecondsForNegativeSingleDigitMinutesSingleDigitSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709034720
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "-4m 9s")
    }

    /// Should return "Xm XXs" for single digit minutes and single digit seconds under 4 minutes 59 seconds
    func testShouldReturnSingleDigitMinutesDoubleDigitSecondsForSingleDigitMinutesDoubleDigitSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709035220
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "4m 11s")
    }

    /// Should return "-Xm XXs" for negative single digit minutes and double digit seconds under 4 minutes 59 seconds
    func testShouldReturnNegativeSingleDigitMinutesDoubleDigitSecondsForNegativeSingleDigitMinutesDoubleDigitSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709034680
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "-4m 49s")
    }

    /// Should return "Xm" for single digit minutes and single digit seconds above 4 minutes 59 seconds
    func testShouldReturnSingleDigitMinutesForSingleDigitMinutesAnyDigitSeconds() throws {
        // Approximately 5 minutes
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709035320
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "5m")
    }

    /// Should return "XXm" for double digit minutes and single digit seconds above 9 minutes 59 seconds
    func testShouldReturnDoubleDigitMinutesForDoubleDigitMinutesAnyDigitSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709035620
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "10m")
    }

    // MARK: - Test Hours

    /// Should return "Xh" for single digit hour less that one minutes
    func testShouldReturnSingleDigitHourForSingleDigitHourZeroMinutesAnyDigitSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        // 1 hour and 40 second difference
        let epoch: TimeInterval = date.timeIntervalSince1970 + (60 * 60) + 40
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "1h")
    }

    /// Should return "Xh Xm" for single digit hour less that ten minutes
    func testShouldReturnSingleDigitHourForSingleDigitHourSingleDigitMinutesAnyDigitSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        // 1 hour and 1 minute 20 second difference
        let epoch: TimeInterval = date.timeIntervalSince1970 + (60 * 60) + 80
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "1h 1m")
    }

    /// Should return "Xh Xm" for single digit hour less that ten minutes - expect to ignore seconds when returning time - 1h 1m 59s should return 1h 1m, not 1h 2m
    func testShouldReturnSingleDigitHourSingleDigitMinuteForSingleDigitHourSingleDigitMinutesIgnoringSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        // 1 hour and 1 minute 50 second difference - expect to ignore seconds.
        let epoch: TimeInterval = date.timeIntervalSince1970 + (60 * 60) + 110
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "1h 1m")
    }

    /// Should return "XXh XXm" for double digit hour any double digit minutes and any digit seconds above 9 hours 59 minutes 59 seconds
    func testShouldReturnDoubleDigitHourForDoubleDigitHourAnyMinutesAnyDigitSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        // 10 hours and 35 minute 10 second difference
        let epoch: TimeInterval = date.timeIntervalSince1970 + (60 * 60 * 10) + (60 * 35) + 10
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "10h 35m")
    }

    // MARK: - Test Edge Cases

    /// Should return "5m" for exactly 5 minutes
    func testShouldReturn5mForFiveMinutesZeroSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709035269
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "5m")
    }

    /// Should return "4m 59s" for exactly 00:04:59
    func testShouldReturn4m59sForFourMinutesFiftyNineSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709035268
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "4m 59s")
    }

    /// Should return "59m" for exactly 00:59:59
    func testShouldReturn59m59sForFiftyNineMinutesFiftyNineSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709038568
        let diff = abs(date.timeIntervalSince(Date(timeIntervalSince1970: epoch)))
        // 59 minutes + 59 seconds
        XCTAssertEqual(diff, 59 * 60 + 59)
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "59m")
    }

    /// Should return "1h" for exactly 00:60:00
    func testShouldReturn1hForSixtyMinutesZeroSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709038569
        let diff = abs(date.timeIntervalSince(Date(timeIntervalSince1970: epoch)))
        // 60 minutes
        XCTAssertEqual(diff, 60 * 60)
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "1h")
    }

    /// Should return "-59s" for exactly -00:00:59
    func testShouldReturnNegative59sForNegativeFiftyNineSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709034910
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "-59s")
    }

    /// Should return "-1m 59s" for exactly -00:01:59
    func testShouldReturnNegative1m59sForNegative1minuteFiftyNineSeconds() throws {
        let date = try XCTUnwrap(mockDate)
        let epoch: TimeInterval = 1709034850
        let displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "-1m 59s")
    }

    /// Caught an edge case where hitting 0 seconds takes 2 seconds to become -1s
    func testShouldReturnCorrectValueForGoingFromPositiveToNegativeWithStaticEpoch() throws {
        let date = Date(timeIntervalSince1970: 1709034850)
        // Set for 1 second more
        var epoch: TimeInterval = 1709034851
        var displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "1s")
        // Set for 0 second more
        epoch = 1709034850
        displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "0s")
        // Set for -1 second more
        epoch = 1709034849
        displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "-1s")
    }

    /// Caught an edge case where hitting 0 seconds takes 2 seconds to become -1s
    func testShouldReturnCorrectValueForGoingFromPositiveToNegativeWithDynamicEpoch() throws {
        let date = Date()
        // Set for 1 second more
        var epoch: TimeInterval = date.timeIntervalSince1970 + 1
        var displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "1s")
        // Set for 0 second more
        epoch = date.timeIntervalSince1970
        displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "0s")
        // Set for -1 second more
        epoch = date.timeIntervalSince1970 - 1
        displayTime = raceCountDownStringHelper.getDisplayString(for: epoch, from: date)
        XCTAssertEqual(displayTime, "-1s")
    }

}

//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by 유민우 on 8/13/24.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager() // 싱글톤 패턴으로 클래스의 유일한 인스턴스를 생성합니다.
    private let apiKey = "1ad11a058dd751ada3c5aa999ddc64a8" // API 키를 저장합니다.
    private let baseUrl = "https://api.openweathermap.org/data/2.5" // API의 기본 URL을 저장합니다.

    private init() {} // 외부에서 인스턴스를 생성하지 못하도록 private 생성자를 만듭니다.

    // 서버에서 현재 날씨 데이터를 불러오는 메서드
    func fetchCurrentWeatherData(lat: Double, lon: Double, completion: @escaping (CurrentWeatherResult?, UIImage?) -> Void) {
        // URLComponents를 사용하여 URL을 구성합니다.
        var urlComponents = URLComponents(string: "\(baseUrl)/weather")
        urlComponents?.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"), // 위도
            URLQueryItem(name: "lon", value: "\(lon)"), // 경도
            URLQueryItem(name: "appid", value: apiKey), // API 키
            URLQueryItem(name: "units", value: "metric") // 온도 단위를 섭씨로 설정
        ]
        // 어디를 바꿔야 url api, CurrentWeatherResult를 말고도 다른 데이터를 변형해서 받는 법을 알아야 한다.
        // urlComponents 바꿀 수 있는 능력 //도시api
        // URL이 제대로 생성되지 않은 경우 처리 //기상청 api바꿔보기 tmdb(영화)//백지로 짜보기
        guard let url = urlComponents?.url else {
            print("잘못된 URL") // URL 생성 실패 시 메시지 출력
            completion(nil, nil) // completion 클로저를 통해 nil 반환
            return
        }

        // 데이터를 가져오는 공통 메서드를 호출
        fetchData(url: url) { (result: CurrentWeatherResult?) in
            // 데이터를 성공적으로 가져왔는지 확인
            guard let result = result else {
                completion(nil, nil) // 실패 시 nil 반환 클로저 활용해서 넘긴다 18번째 줄 참고
                return
            }

            // 날씨 아이콘을 불러오기 위해 아이콘 URL 생성
            guard let icon = result.weather.first?.icon,
                  let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else {
                completion(result, nil) // 아이콘 URL 생성 실패 시 데이터만 반환
                return
            }

            // 이미지를 불러옴
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(result, image) // 성공적으로 이미지 로드 시 이미지와 데이터를 반환
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(result, nil) // 이미지 로드 실패 시 데이터만 반환
                    }
                }
            }
        }
    }

    // 공통 네트워크 요청 메서드//클린아키텍처 공부
    private func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
        let session = URLSession(configuration: .default) // 기본 설정으로 URLSession 인스턴스를 생성합니다.
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                print("데이터 로드 실패") // 데이터 로드 실패 시 메시지 출력
                completion(nil) // nil 반환
                return
            }

            let successRange = 200..<300 // HTTP 상태 코드에서 성공을 나타내는 범위
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    print("JSON 디코딩 실패") // JSON 디코딩 실패 시 메시지 출력
                    completion(nil) // nil 반환
                    return
                }
                completion(decodedData) // 디코딩 성공 시 데이터를 반환
            } else {
                print("응답 오류") // 응답 오류 시 메시지 출력
                completion(nil) // nil 반환
            }
        }.resume() // 요청 시작
    }
}

// CurrentWeatherResult와 ForecastWeatherResult 모델 정의
struct CurrentWeatherResult: Codable {
    let weather: [Weather] // 날씨 정보 배열
    let main: WeatherMain // 주요 날씨 정보 (온도, 습도 등)
}

struct Weather: Codable {
    let id: Int // 날씨 ID
    let main: String // 날씨 상태 (예: "Clear")
    let description: String // 날씨 설명 (예: "clear sky")
    let icon: String // 날씨 아이콘의 파일명
}

struct WeatherMain: Codable {
    let temp: Double // 현재 온도
    let temp_min: Double // 최저 온도
    let temp_max: Double // 최고 온도
    let humidity: Int // 습도
}

struct ForecastWeatherResult: Codable {
    let list: [ForecastWeather] // 날씨 예보 리스트
}

struct ForecastWeather: Codable {
    let main: WeatherMain // 주요 날씨 정보 (온도, 습도 등)
    let dtTxt: String // 날짜와 시간 정보

    enum CodingKeys: String, CodingKey {
        case main // JSON 키와 구조체 키의 매핑
        case dtTxt = "dt_txt" // JSON에서 "dt_txt" 키를 "dtTxt" 변수와 매핑
    }
}
